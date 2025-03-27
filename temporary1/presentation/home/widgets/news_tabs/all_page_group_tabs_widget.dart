import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/presentation/home/cubit/news_tabs/tabs_cubit.dart';
import 'package:startopreneur/presentation/home/widgets/news_tabs/news_banner_widget.dart';

class AllPageGroupTabsWidget extends StatelessWidget {
  final String? newsCategory;
  final BuildContext contextMain;
  final int index;
  final List<Item?> items;
  final String? channelTitle;
  final String topicId;

  const AllPageGroupTabsWidget({
    super.key,
    this.newsCategory,
    required this.contextMain,
    required this.index,
    required this.items,
    this.channelTitle,
    required this.topicId
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                channelTitle ?? "",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              InkWell(
                  onTap: () => contextMain.read<TabsCubit>().changeTab(channelTitle ?? ""),
                  child: Text('View more')),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final item = items[index];
              return NewsBannerWidget(
                topicId: topicId,
                title: item?.title,
                articleImage: item?.content?.url,
                date: item?.pubDate,
                pageUrl: item?.link,
                channelTitle: newsCategory,
              );
            },
          ),
        ),
      ],
    );
  }
}
