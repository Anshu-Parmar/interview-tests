import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/user_bookmarks_cubit.dart';
import 'package:startopreneur/presentation/home/widgets/news_tabs/news_banner_widget.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> with AutomaticKeepAliveClientMixin<BookmarkPage>{
  @override
  bool get wantKeepAlive => true;

  // @override
  // void dispose() {
  //   context.read<UserBookmarksCubit>().closeStream();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bookmarks',
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => context.read<UserBookmarksCubit>().loadBookmarkTitles(context),
        color: AppColors.primaryColor,
        child: BlocBuilder<UserBookmarksCubit, UserBookmarksState>(
          builder: (context, state) {
            if (state is UserBookmarksLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            if (state is UserBookmarksLoaded) {
              if (state.bookmarkItem.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppVectors.noData,
                        fit: BoxFit.scaleDown,
                        height: 150,
                      ),
                      const SizedBox(height: 10.0,),
                      Text('NO BOOKMARKS')
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        itemCount: state.bookmarkItem.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = state.bookmarkItem[index];

                          return NewsBannerWidget(
                            topicId: item!.topicId ,
                            title: item.title,
                            articleImage: item.imageUrl,
                            date: item.pubDate,
                            pageUrl: item.link,
                            channelTitle: item.channelTitle,
                            isBookmarked: item.isBookmarked,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is UserBookmarksError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppVectors.noData,
                      fit: BoxFit.scaleDown,
                      height: 150,
                    ),
                    const SizedBox(height: 10.0,),
                    Text('NO BOOKMARKS')
                  ],
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
