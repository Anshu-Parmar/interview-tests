import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/common/widget/debouce/single_tap.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/constants/global_constants.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/add_or_remove_bookmark/add_or_remove_bookmark_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/user_bookmarks_cubit.dart';
import 'package:startopreneur/presentation/news/cubit/webview/webview_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebNewsPage extends StatefulWidget {
  final BookMarkItem bookMarkItem;

  const WebNewsPage({super.key, required this.bookMarkItem});

  @override
  State<WebNewsPage> createState() => _WebNewsPageState();
}

class _WebNewsPageState extends State<WebNewsPage> with WidgetsBindingObserver {
  late final WebViewController _controller;
  bool _shouldRestore = false;
  var canPop = false;
  bool errorInternet = false;
  TargetPlatform? _platform;

  @override
  void initState() {
    super.initState();
    final targetUri = Uri.parse(widget.bookMarkItem.link!);
    final hostName = targetUri.host;
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          log('Page started loading: $url', name: 'WEBVIEW');
          context.read<WebViewCubit>().setLoading(0);
        },
        onProgress: (int progress) {
          if (progress > 80 && !errorInternet) {
            context.read<WebViewCubit>().setLoaded();
          } else if (progress <= 80 && !errorInternet) {
            context.read<WebViewCubit>().setLoading(progress);
          }
        },
        onPageFinished: (String url) {
          log('Page finished loading: $url', name: 'WEBVIEW');
        },
        onHttpError: (HttpResponseError error) async {
          log(error.response!.statusCode.toString(), name: 'WEBVIEW');
          if (error.toString().contains('ERR_UNKNOWN_URL_SCHEME')) {
            await controller.goBack();
          }
        },
        onHttpAuthRequest: (HttpAuthRequest request) {
          log(request.host.toString(), name: 'WEBVIEW');
        },
        onUrlChange: (UrlChange change) {
          log("Url change to - ${change.url.toString()}", name: 'WEBVIEW');
        },
        onWebResourceError: (error) async {
          // debugPrint('''
          //     Page resource error:
          //     code: ${error.errorCode}
          //     description: ${error.description}
          //     errorType: ${error.errorType}
          //     isForMainFrame: ${error.isForMainFrame}
          // ''');
          if (error.description.contains('net::ERR_INTERNET_DISCONNECTED')) {
            errorInternet = true;
            context.read<WebViewCubit>().setError();
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://$hostName') || request.url.startsWith('http://$hostName')) {
            log('Allowing navigation to ${request.url}', name: 'WEBVIEW');
            return NavigationDecision.navigate;
          } else {
            log('Blocking navigation to ${request.url}', name: 'WEBVIEW');
            return NavigationDecision.prevent;
          }
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.bookMarkItem.link!));

    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;

    _platform = targetPlatform;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _shouldRestore = true;
    } else if (state == AppLifecycleState.resumed && _shouldRestore) {
      _shouldRestore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkCubit = CubitManager().getCubit(widget.bookMarkItem.title!)
      ..justToggleBookmark(context.read<UserBookmarksCubit>().checkBookmarkTitleHas(widget.bookMarkItem.title!));
    Color bkgColor = context.isDarkMode ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor;

    return Scaffold(
      backgroundColor: bkgColor,
      appBar: AppBar(
        title: const Text(' '),
        backgroundColor: bkgColor,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.adaptive.arrow_back_rounded)),
        actions: [
          BlocBuilder<WebViewCubit, WebViewState>(
            builder: (context, webState) {
              if (webState.status == WebViewStatus.error) {
                return _appBarOptions(
                    key: null,
                    context: context,
                    icon: Icons.refresh,
                    onTap: () async {
                      _controller.reload();
                      context.read<WebViewCubit>().setLoading(0);
                      service.HapticFeedback.mediumImpact();
                    });
              } else {
                return Row(
                  children: [
                    BlocBuilder<AddOrRemoveBookmarkCubit, bool>(
                      bloc: bookmarkCubit,
                      builder: (context, bState) {
                        return BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return _appBarOptions(
                              key: null,
                              context: context,
                              onTap: () {
                                if (state is Authenticated) {
                                  if (!bState) {
                                    // log("ADDED-bookmark", name: 'BOOKMARKS');
                                    context.read<UserBookmarksCubit>().addBookmarkTitle(widget.bookMarkItem.title!);
                                    SnackBarDisplay(
                                      context: context,
                                      message: 'Bookmark Added',
                                      time: 1800,
                                    ).showSnackBar();
                                  } else {
                                    // log("REMOVED-bookmark", name: 'BOOKMARKS');
                                    context.read<UserBookmarksCubit>().removeBookmarkTitle(widget.bookMarkItem.title!);
                                    SnackBarDisplay(
                                      context: context,
                                      message: 'Bookmark Removed',
                                      time: 1800,
                                    ).showSnackBar();
                                  }
                                  bookmarkCubit.toggleBookMark(BookMarkItem(
                                      topicId: widget.bookMarkItem.topicId,
                                      title: widget.bookMarkItem.title,
                                      channelTitle: widget.bookMarkItem.channelTitle,
                                      link: widget.bookMarkItem.link,
                                      pubDate: widget.bookMarkItem.pubDate,
                                      imageUrl: widget.bookMarkItem.imageUrl,
                                      isBookmarked: !bState));
                                } else if (state is Unauthenticated) {
                                  if (SingleTapDetector.isClicked == false) {
                                    SingleTapDetector.startTimer();
                                    SingleTapDetector.isClicked = true;
                                    SnackBarDisplay(
                                      context: context,
                                      message: ErrorMessages.logInFirst,
                                      time: 1800,
                                      isActionEnabled: true,
                                      bookMarkItem: BookMarkItem(
                                        topicId: widget.bookMarkItem.topicId,
                                        title: widget.bookMarkItem.title,
                                        channelTitle: widget.bookMarkItem.channelTitle,
                                        link: widget.bookMarkItem.link,
                                        pubDate: widget.bookMarkItem.pubDate,
                                        imageUrl: widget.bookMarkItem.imageUrl,
                                        isBookmarked: !bState,
                                      ),
                                      tabIndex: 1,
                                    ).showSnackBar();
                                  }
                                }

                                service.HapticFeedback.mediumImpact();
                              },
                              icon: state is Authenticated
                                  ? bState
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline
                                  : Icons.bookmark_outline,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                    Builder(builder: (BuildContext context) {
                      final size = MediaQuery.sizeOf(context);
                      return _appBarOptions(
                          key: null,
                          context: context,
                          icon: Icons.share_outlined,
                          onTap: () async {
                            final url = Uri.parse(widget.bookMarkItem.link!);
                            await Share.share(
                              url.toString(),
                              subject: "Check out this link!",
                              //REQUIRED FOR IPad - necessary parameter to use share feature in iPads
                              sharePositionOrigin: Rect.fromPoints(
                                Offset(size.width - 10, 50),
                                Offset(size.width, 0),
                              ),
                            );
                          });
                    }),
                    const SizedBox(width: 10),
                  ],
                );
              }
            },
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.zero,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: SizedBox(),
        ),
      ),
      body: BlocBuilder<WebViewCubit, WebViewState>(
        builder: (context, webState) {
          if (webState.status == WebViewStatus.loading) {
            return Center(
              child: AspectRatio(
                aspectRatio: 1/3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      color: AppColors.primaryColor,
                      value: webState.progress / 100,
                      minHeight: 30,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    // CircularProgressIndicator(
                    //   color: AppColors.primaryColor,
                    //   strokeWidth: 3,
                    //   value: webState.progress / 100,
                    // ),
                    Text("Loading ... ${webState.progress}%")
                  ],
                ),
              ),
            );
          }
          else if (webState.status == WebViewStatus.loaded) {
            return _platform == TargetPlatform.android
                ? PopScope(
              canPop: canPop,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) {
                  return;
                }
                if (await _controller.canGoBack()) {
                  _controller.goBack();
                } else {
                  canPop = true;
                  if (context.mounted && canPop) {
                    Navigator.pop(context);
                  }
                }
              },
              child: WebViewWidget(
                controller: _controller,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()),
                },
              ),
            )
                : WebViewWidget(
              controller: _controller,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()),
              },
            );
          }
          else {
            return SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppVectors.noNews,
                    fit: BoxFit.scaleDown,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                        )),
                    child: Icon(
                      Icons.new_releases,
                      size: 40,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppTexts.noNews,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppTexts.noNewsDescription),
                      Text(AppTexts.noNewsDescription2),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _appBarOptions(
      {double radius = 30,
      required VoidCallback? onTap,
      required IconData? icon,
      required BuildContext context,
      required Key? key}) {
    Color currentColor = context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor;

    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      splashColor: currentColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? AppColors.darkBackgroundColor.withValues(alpha: 0.5)
                  : AppColors.lightBackgroundColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: currentColor,
              grade: 2,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
