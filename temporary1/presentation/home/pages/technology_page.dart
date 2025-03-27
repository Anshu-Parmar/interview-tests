import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/widget/debouce/single_tap.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/presentation/home/cubit/news_tabs/tabs_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/technology_news/tech_news_cubit.dart';
import 'package:startopreneur/presentation/home/widgets/news_tabs/news_banner_widget.dart';

class TechnologyPage extends StatefulWidget {
  const TechnologyPage({super.key});

  @override
  State<TechnologyPage> createState() => _TechnologyPageState();
}

class _TechnologyPageState extends State<TechnologyPage>
    with AutomaticKeepAliveClientMixin<TechnologyPage> {
  @override
  bool get wantKeepAlive {
    return BlocProvider.of<TabsCubit>(context).state.activeTabs.contains(5);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: () => context.read<TechNewsCubit>().loadTechNews(),
      color: AppColors.primaryColor,
      child: BlocBuilder<TechNewsCubit, TechNewsState>(
        builder: (context, state) {
          if (state is TechNewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TechNewsLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Text('NO NEWS'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: state.items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return NewsBannerWidget(
                          topicId: item!.topicId,
                          title: item.title,
                          articleImage: item.imageUrl,
                          date: item.pubDate,
                          pageUrl: item.link,
                          channelTitle: item.channelTitle,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is TechNewsError) {
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
                  const SizedBox(height: 10,),
                  IconButton(
                    onPressed: () {
                      if (SingleTapDetector.isClicked == false) {
                        SingleTapDetector.startTimer(time: 3000);
                        SingleTapDetector.isClicked = true;
                        context.read<TechNewsCubit>().loadTechNews();
                      }
                      service.HapticFeedback.mediumImpact();
                    },
                    color: AppColors.primaryColor,
                      style: IconButton.styleFrom(
                        shape: CircleBorder(
                          side: BorderSide(color: AppColors.primaryColor)
                        )
                      ),
                    constraints: BoxConstraints(),
                    iconSize: 40,
                    padding: EdgeInsets.all(20),
                      splashColor: Colors.red,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.refresh, size: 40,)
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(AppTexts.noNews, style: TextStyle(decoration: TextDecoration.underline),),
                  const SizedBox(height: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppTexts.noNewsDescription),
                      if (state.message.toLowerCase().contains("socket")) ...[
                        Text(AppTexts.noNewsDescription2),
                      ],
                      if (state.message.toLowerCase().contains("empty")) ...[
                        Text(AppTexts.noNewsDescriptionTechnology),
                      ]
                    ],
                  )
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
