import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/widget/text_widget/text_widget.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';

import 'package:startopreneur/presentation/home/widgets/carousel/cubit/carousel_cubit.dart';

class CarouselWidget extends StatefulWidget {
  final List<Channel?> allTopics;
  final double height;
  final double width;

  const CarouselWidget({super.key, required this.height, required this.width, required this.allTopics});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> carouselItems = [];

  @override
  void initState() {
    super.initState();
    carouselItems = getRandomItemsFromTopics(widget.allTopics);
    _pageController.addListener(() {
      if (_pageController.page == carouselItems.length.toDouble()) {
        Future.delayed(
          const Duration(milliseconds: 200),
              () => _pageController.jumpToPage(0),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: context.isDarkMode ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
                spreadRadius: -1,
                blurRadius: 15,
                offset: const Offset(-5, -5),
              )
            ],
          ),
          child: PageView.builder(
            // itemCount: carouselItems.length + 1 == 1 ? 0 : carouselItems.length + 1,
            itemCount: carouselItems.length,
            controller: _pageController,
            onPageChanged: (int value) => context.read<CarouselCubit>().nextCarouselPage(value),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              // if (index == carouselItems.length) {
              //   return Container(
              //     color: AppColors.primaryColor,
              //   );
              // } else {
                final item = carouselItems[index]['item'];
                final category = carouselItems[index]['title'];
                final channel = carouselItems[index]['channel'];
                final topicId = carouselItems[index]['topicId'];
                // final bookmarkCubit = CubitManager().getCubit(category!)
                //   ..justToggleBookmark(context.read<UserBookmarksCubit>().checkBookmarkTitleHas(category!));

                return InkWell(
                  onTap: () {
                    if (item.link != null || item.link != "") {
                      Navigator.pushNamed(
                        context,
                        RouteNames.webNewsPage,
                        arguments: BookMarkItem(
                            topicId: topicId,
                            title: item?.title,
                            channelTitle: channel,
                            link: item?.link,
                            pubDate: item?.pubDate,
                            imageUrl: item?.content?.url,
                            isBookmarked: false
                        ),
                      );
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) =>
                      //           WebNewsPage(
                      //             bookMarkItem: BookMarkItem(
                      //                 topicId: topicId,
                      //                 title: item?.title,
                      //                 channelTitle: channel,
                      //                 link: item?.link,
                      //                 pubDate: item?.pubDate,
                      //                 imageUrl: item?.content?.url,
                      //                 isBookmarked: false),
                      //           ),
                      //     ));
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              alignment: Alignment.topCenter,
                              fit: BoxFit.cover,
                              image: item?.content?.url == null
                                  ? AssetImage(AppImages.temp)
                                  : NetworkImage(item?.content?.url)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: widget.height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 1),
                              ],
                            ),
                          ),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0),
                          ),
                        ),
                      ),
                      // BlocBuilder<AddOrRemoveBookmarkCubit, bool>(
                      //   bloc: bookmarkCubit,
                      //   builder: (context, bState) {
                      //     return Positioned(
                      //       top: 15,
                      //       right: 15,
                      //       child: BlocBuilder<AuthCubit, AuthState>(
                      //         builder: (context, state) {
                      //           return InkWell(
                      //             onTap: () {
                      //               if(state is Authenticated) {
                      //               if (!bState) {
                      //                 context.read<UserBookmarksCubit>().addBookmarkTitle(category!);
                      //                 SnackBarDisplay(
                      //                   context: context,
                      //                   message: 'Bookmark Added',
                      //                   time: 1800,
                      //                 ).showSnackBar();
                      //               } else {
                      //                 context.read<UserBookmarksCubit>().removeBookmarkTitle(category!);
                      //                 SnackBarDisplay(
                      //                   context: context,
                      //                   message: 'Bookmark Removed',
                      //                   time: 1800,
                      //                 ).showSnackBar();
                      //               }
                      //               bookmarkCubit.toggleBookMark(BookMarkItem(
                      //                   topicId: topicId,
                      //                   title: item?.title,
                      //                   channelTitle: channel,
                      //                   link: item?.link,
                      //                   pubDate: item?.pubDate,
                      //                   imageUrl: item?.content?.url,
                      //                   isBookmarked: !bState)
                      //               );
                      //             }
                      //
                      //             if (state is Unauthenticated){
                      //               if (SingleTapDetector.isClicked == false) {
                      //                 SingleTapDetector.startTimer();
                      //                 SingleTapDetector.isClicked = true;
                      //                 SnackBarDisplay(
                      //                   context: context,
                      //                   message: ErrorMessages.logInFirst,
                      //                   time: 1800,
                      //                 ).showSnackBar();
                      //               }
                      //             }
                      //
                      //             },
                      //             splashColor: Colors.red,
                      //             splashFactory: InkSparkle.splashFactory,
                      //             child: Container(
                      //               height: 40,
                      //               width: 40,
                      //               decoration: BoxDecoration(
                      //                 shape: BoxShape.circle,
                      //                 color: AppColors.darkBackgroundColor.withValues(alpha: 0.3),
                      //               ),
                      //               alignment: Alignment.center,
                      //               child: Icon(
                      //                 state is Authenticated
                      //                     ? bState
                      //                     ? Icons.bookmark
                      //                     : Icons.bookmark_outline
                      //                     : Icons.bookmark_outline,
                      //                 size: 25,
                      //                 color: AppColors.lightBackgroundColor,
                      //               )
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     );
                      //   },
                      // ),
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: widget.height - 150, bottom: 5),
                                color: Colors.transparent,
                                child: TextWidget(
                                  text: item.title ?? "",
                                  fontAddSize: 4,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 3,
                                  textOverFlow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                  child: Text(
                                    channel ?? "",
                                    style: TextStyle(color: Colors.green),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 5,
                        right: 0,
                        top: 15,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    height: 30,
                                    alignment: Alignment.center,
                                    color: AppColors.darkBackgroundColor.withValues(alpha: 0.3),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      (category ?? "").toString().toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.lightBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                );
              // }
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: Align(
              alignment: Alignment.center,
              child: BlocBuilder<CarouselCubit, CarouselState>(
                builder: (context, state) {
                  return Container(
                    height: 15,
                    width: carouselItems.length * 15,
                    alignment: Alignment.center,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: carouselItems.length,
                      itemBuilder: (context, index) {
                        if (state.selectedIndex == index) {
                          return Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else {
                          return Container(
                            height: 5,
                            width: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          );
                        }
                      },
                      separatorBuilder: (_, index) =>
                      const SizedBox(
                        width: 5,
                      ),
                    ),
                  );
                },
              )
          ),
        )
      ],
    );
  }

  List<Map<String, dynamic>> getRandomItemsFromTopics(List<Channel?> allTopics) {
    final random = Random();
    final List<Map<String, dynamic>> result = [];

    for (var channel in allTopics) {
      if (channel != null && channel.items.isNotEmpty) {
        var randomItem = channel.items[random.nextInt(channel.items.length)];
        if (randomItem.content?.url != null) {
          result.add({
            'title': channel.description,
            'channel': channel.title,
            'topicId': channel.topicId,
            'item': randomItem,
          });
        }
      }
    }

    for (var i = allTopics.length - 1; i >= 0; i--) {
      var channel = allTopics[i];
      if (channel != null && channel.items.isNotEmpty) {
        Item randomItem;
        do {
          randomItem = channel.items[random.nextInt(channel.items.length)];
        } while (result.any((element) => element['item'] == randomItem));

        result.add({
          'title': channel.description,
          'channel': channel.title,
          'topicId': channel.topicId,
          'item': randomItem,
        });
      }
    }
    result.shuffle();
    return result;
  }
}
