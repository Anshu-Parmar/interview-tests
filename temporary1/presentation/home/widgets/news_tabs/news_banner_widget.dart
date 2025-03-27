import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/common/widget/debouce/single_tap.dart';
import 'package:startopreneur/common/widget/text_widget/text_widget.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/add_or_remove_bookmark/add_or_remove_bookmark_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/user_bookmarks_cubit.dart';
// import 'package:startopreneur/presentation/settings/cubit/display_settings_cubit/font_size_cubit.dart';

class NewsBannerWidget extends StatelessWidget {
  final String? title;
  final String? pageUrl;
  final String? date;
  final String? articleImage;
  final String? channelTitle;
  final bool isBookmarked;
  final String topicId;

  const NewsBannerWidget({super.key,
    this.title,
    this.pageUrl,
    this.date,
    this.articleImage,
    this.channelTitle,
    this.isBookmarked = false,
    required this.topicId});

  @override
  Widget build(BuildContext context) {
    // log('BANNER REBUILT');

    final bookmarkCubit = CubitManager().getCubit(title!)
      ..justToggleBookmark(context.read<UserBookmarksCubit>().checkBookmarkTitleHas(title!));
    double size = 157;

    return BlocProvider<AddOrRemoveBookmarkCubit>(
        create: (context) => AddOrRemoveBookmarkCubit(title!),
        // child: BlocBuilder<FontSizeCubit, double>(
        //   builder: (context, state) {
        //     double size = 143;
        //
        //     switch (state) {
        //       case 0.0:
        //         size = 145;
        //         break;
        //       case 1.0:
        //         size = 157;
        //         break;
        //       case 3.0:
        //         size = 162;
        //         break;
        //       case 4.0:
        //         size = 169;
        //         break;
        //       case 5.0:
        //         size = 178;
        //         break;
        //     }

        child: Container(
              height: size,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: context.isDarkMode ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  border: context.isDarkMode ? Border.all(color: AppColors.lightBackgroundColor.withValues(alpha: 0.2)) : Border(),
                  boxShadow: [
                    BoxShadow(
                      color: context.isDarkMode ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
                      spreadRadius: -1,
                      blurRadius: 15,
                      offset: const Offset(-5, -5),
                    )
                  ]),
              child: BlocBuilder<AddOrRemoveBookmarkCubit, bool>(
                bloc: bookmarkCubit,
                builder: (context, bState) {
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.webNewsPage,
                      arguments:  BookMarkItem(
                        topicId: topicId,
                        title: title,
                        channelTitle: channelTitle,
                        link: pageUrl,
                        pubDate: date,
                        imageUrl: articleImage,
                        isBookmarked: !bState
                      )
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: date ?? DateTime.now().toString(),
                                        fontAddSize: -4,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      BlocBuilder<AuthCubit, AuthState>(
                                        builder: (context, state) {
                                          return IconButton(
                                              onPressed: () {
                                                if (state is Authenticated) {
                                                  if (!bState) {
                                                    log('ADDED-bookmark');
                                                    context.read<UserBookmarksCubit>().addBookmarkTitle(title!);
                                                    SnackBarDisplay(
                                                      context: context,
                                                      message: 'Bookmark Added',
                                                      time: 1800,
                                                    ).showSnackBar();
                                                    bookmarkCubit.toggleBookMark(BookMarkItem(
                                                        topicId: topicId,
                                                        title: title,
                                                        channelTitle: channelTitle,
                                                        link: pageUrl,
                                                        pubDate: date,
                                                        imageUrl: articleImage,
                                                        isBookmarked: !bState));
                                                  } else {
                                                    _removeBookmarkDialog(context, title: title ?? "", bookmarkItem: BookMarkItem(
                                                        topicId: topicId,
                                                        title: title,
                                                        channelTitle: channelTitle,
                                                        link: pageUrl,
                                                        pubDate: date,
                                                        imageUrl: articleImage,
                                                        isBookmarked: !bState),
                                                        bookmarkCubit: bookmarkCubit, bState: bState
                                                    );
                                                  }
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
                                                        topicId: topicId,
                                                        title: title,
                                                        channelTitle: channelTitle,
                                                        link: pageUrl,
                                                        pubDate: date,
                                                        imageUrl: articleImage,
                                                        isBookmarked: !bState,),
                                                        tabIndex: 1,
                                                    ).showSnackBar();
                                                  }
                                                }

                                                service.HapticFeedback.mediumImpact();
                                              },
                                              padding: EdgeInsets.all(5),
                                              constraints: BoxConstraints(minHeight: 30, minWidth: 30),
                                              visualDensity: VisualDensity(
                                                  horizontal: VisualDensity.minimumDensity,
                                                  vertical: VisualDensity.minimumDensity),
                                              icon: Icon(
                                                state is Authenticated
                                                    ? bState
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_outline
                                                    : Icons.bookmark_outline,
                                                size: 25,
                                              ));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: TextWidget(
                                      text: title ?? '',
                                      maxLines: 3,
                                      fontAddSize: 4,
                                      fontWeight: FontWeight.w600,
                                      textOverFlow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    channelTitle ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                        color: AppColors.primaryColor),
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: size,
                            width: 100,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                            ),
                            child: articleImage != null
                                ? CachedNetworkImage(
                              imageUrl: articleImage!,
                              cacheKey: title,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) {
                                // log('IMAGE REBUILT');
                                return SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        strokeWidth: 2,
                                      )),
                                );
                              },
                              errorWidget: (context, url, error) {
                                log("IMAGE ERROR - $articleImage | $error");
                                return const Icon(Icons.error);
                              },
                            )
                                : Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Image.asset(
                                AppImages.logo,
                                fit: BoxFit.contain,
                              ),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
        //   },
        // )
    );
  }

  void _removeBookmarkDialog(BuildContext context, {required String title, required BookMarkItem bookmarkItem, required AddOrRemoveBookmarkCubit bookmarkCubit, required bool bState}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove bookmark', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
          content: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyle(
                color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor,
                height: 1.3
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Are you sure you want to remove - ',
                ),
                TextSpan(
                  text: title,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ' from bookmarks ?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.all(5)),
              child: Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600, color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.all(5)),
              child: Text(
                "Remove",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
              ),
              onPressed: () {
                log('REMOVED-bookmark');
                context.read<UserBookmarksCubit>().removeBookmarkTitle(title);
                bookmarkCubit.toggleBookMark(BookMarkItem(
                    topicId: topicId,
                    title: title,
                    channelTitle: channelTitle,
                    link: pageUrl,
                    pubDate: date,
                    imageUrl: articleImage,
                    isBookmarked: !bState));

                Navigator.pop(context);
                SnackBarDisplay(
                  context: context,
                  message: 'Bookmark Removed',
                  time: 1800,
                ).showSnackBar();
              },
            ),
          ],
        );
      },
    );
  }
}

extension RemoveBeforeSymbol on String {
  String removeBeforeSymbol() {
    final index = indexOf('>');
    return index != -1 ? substring(index + 1) : this;
  }
}
