
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/shimmer_effect.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/presentation/home/cubit/all_news/all_news_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/business_news/business_news_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/funding/funding_news_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/management_news/management_news_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/news_tabs/tabs_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/productivity_news/productivity_news_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/technology_news/tech_news_cubit.dart';
import 'package:startopreneur/presentation/home/pages/business_page.dart';
import 'package:startopreneur/presentation/home/pages/funding_page.dart';
import 'package:startopreneur/presentation/home/pages/management_page.dart';
import 'package:startopreneur/presentation/home/pages/productivity_page.dart';
import 'package:startopreneur/presentation/home/pages/technology_page.dart';
import 'package:startopreneur/presentation/home/widgets/carousel/carousel_widget.dart';
import 'package:startopreneur/presentation/home/widgets/carousel/cubit/carousel_cubit.dart';
import 'package:startopreneur/presentation/home/widgets/news_tabs/all_page_group_tabs_widget.dart';

class AllPage extends StatefulWidget {
  final List<Channel?> allTopics;

  const AllPage({super.key, required this.allTopics});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<AllPage> {
  late TabController _tabController;
  List<String> tabNames = [];
  List<Tab> myTabs = [];
  List<Widget> pageBodies = [];

  @override
  void initState() {

    super.initState();
    tabNames = ["ALL", "Business", "Funding", "Management", "Productivity", "Technology"];
    _tabController = TabController(length: tabNames.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        String title = "HOME";

        switch (_tabController.index) {
          case 0:
            title = "HOME";
            break;
          case 1:
            title = "BUSINESS";
            break;
          case 2:
            title = "FUNDING";
            break;
          case 3:
            title = "MANAGEMENT";
            break;
          case 4:
            title = "PRODUCTIVITY";
            break;
          case 5:
            title = "TECHNOLOGY";
            break;
          default:
            title = "HOME";
            break;
        }
        context.read<TabsCubit>().changeTab(title);
      }
    });
    myTabs = List.generate(
      tabNames.length,
      (index) => Tab(text: tabNames[index].toUpperCase()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',

        ///NOTIFICATION ICON IMPLEMENTATION
        // actionIcon: Padding(
        //   padding: const EdgeInsets.only(right: 15.0),
        //   child: IconButton(
        //       onPressed: () {
        //         // Navigator.pop(context);
        //         ///FirebaseCrashlytics.instance.crash();
        //       },
        //       icon: Container(
        //           decoration: const BoxDecoration(
        //             // color: context.isDarkMode ?  Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.04),
        //               shape: BoxShape.circle),
        //           child: SvgPicture.asset(AppVectors.notification)
        //       )
        //   ),
        // ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 35,
            child: TabBar(
              controller: _tabController,
              tabs: myTabs,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
            ),
          ),
          BlocListener<TabsCubit, TabsState>(
            listener: (context, state) {
              _tabController.animateTo(state.currentIndex);
            },
            child: Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  AllPageBody(allTopics: widget.allTopics),
                  BlocProvider<BusinessNewsCubit>(
                    create: (context) => BusinessNewsCubit()..loadBusinessNews(),
                    child: BusinessPage(),
                  ),
                  BlocProvider<FundingNewsCubit>(
                    create: (context) => FundingNewsCubit()..loadFundingNews(),
                    child: FundingPage(),
                  ),
                  BlocProvider<ManagementNewsCubit>(
                    create: (context) => ManagementNewsCubit()..loadManagementNews(),
                    child: ManagementPage(),
                  ),
                  BlocProvider<ProductivityNewsCubit>(
                    create: (context) => ProductivityNewsCubit()..loadProductivityNews(),
                    child: ProductivityPage(),
                  ),
                  BlocProvider<TechNewsCubit>(
                    create: (context) => TechNewsCubit()..loadTechNews(),
                    child: TechnologyPage(),
                  ),
                  // pageBodies[1]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AllPageBody extends StatefulWidget {
  final List<Channel?> allTopics;

  const AllPageBody({super.key, required this.allTopics});

  @override
  State<AllPageBody> createState() => _AllPageBodyState();
}

class _AllPageBodyState extends State<AllPageBody> with AutomaticKeepAliveClientMixin<AllPageBody> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = MediaQuery.sizeOf(context).height * 0.5;
    final width = MediaQuery.sizeOf(context).width - 32;

    return RefreshIndicator.adaptive(
      onRefresh: () => context.read<AllNewsCubit>().loadAllNews(),
      color: AppColors.primaryColor,
      child: SingleChildScrollView(
          child: widget.allTopics.isNotEmpty
              ? Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    BlocProvider<CarouselCubit>(
                      create: (context) => CarouselCubit(),
                      child: CarouselWidget(
                        height: height,
                        width: width,
                        allTopics: widget.allTopics,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ...widget.allTopics.asMap().entries.map((entry) {
                      int index = entry.key + 1; // Start index from 1
                      var data = entry.value;

                      return AllPageGroupTabsWidget(
                        topicId: data?.topicId ?? "",
                        items: data!.items,
                        contextMain: context,
                        index: index,
                        channelTitle: data.description,
                        newsCategory: data.title,
                      );
                    })
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CustomShimmer(
                        height: height,
                        width: width,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      CustomShimmer(
                        height: 160,
                        width: width,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomShimmer(
                        height: 160,
                        width: width,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )),
    );
  }
}
