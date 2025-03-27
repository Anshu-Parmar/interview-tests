import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/core/configs/constants/global_constants.dart';
import 'package:startopreneur/core/configs/intents/cubits/deep_link_cubit.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/user_bookmarks_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/pages/landing_bookmark_page.dart';
import 'package:startopreneur/presentation/home/cubit/all_news/all_news_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/news_tabs/tabs_cubit.dart';
import 'package:startopreneur/presentation/home/pages/all_page/all_page.dart';
import 'package:startopreneur/presentation/home/pages/all_page/all_page_skeleton.dart';
import 'package:startopreneur/presentation/profile/cubit/current_user_cubit.dart';
import 'package:startopreneur/presentation/profile/pages/landing_page_profile.dart';

late TabController tabController;

class HomePage extends StatefulWidget {
  final int storedIndex;

  const HomePage({super.key, this.storedIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage> {
  final List<IconData> tabNames = [Icons.home_outlined, Icons.bookmark_outline, Icons.person_outline];
  List<Tab> myTabs = [];
  double? bottomInsets;
  TargetPlatform? _platform;

  @override
  void initState() {
    super.initState();
    _platform = targetPlatform;
    tabController = TabController(length: tabNames.length, vsync: this);
    myTabs = List.generate(
      3,
          (index) =>
          Tab(
            icon: Icon(
              tabNames[index],
            ),
            iconMargin: EdgeInsets.zero,
          ),
    );
    if (widget.storedIndex != 0) {
      tabController.index = widget.storedIndex;
    }
  }

  @override
  void dispose() {
    tabController.dispose;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    bottomInsets ??= MediaQuery
        .viewPaddingOf(context)
        .bottom;

    super.build(context);
    bool authenticated = false;
    return  BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) authenticated = true;
        if (state is Unauthenticated) authenticated = false;
      },
      child: BlocListener<DeepLinkCubit, String?>(
        listener: (context, deeplink) {
          if (deeplink != null) {
            final temp = Uri.parse(deeplink);
            String? uri;
            if (authenticated) {
              uri = "/deeplink/${temp.pathSegments.last}";
            } else {
              final String last = "/${temp.pathSegments.last}";
              switch (last) {
                case RouteNames.channelPage:
                  uri = RouteNames.login;
                case RouteNames.settings:
                  uri = RouteNames.guestSettings;
                case RouteNames.editProfilePage:
                  uri = RouteNames.login;
                case RouteNames.login:
                  uri = RouteNames.login;
                case RouteNames.signup:
                  uri = RouteNames.signup;
                case RouteNames.forgotPwd:
                  uri = RouteNames.forgotPwd;
                case RouteNames.displaySetting:
                  uri = RouteNames.displaySetting;
                case "/bookmarks":
                  uri = "/bookmarks";
                case "/profile":
                  uri = "/profile";
              }
            }
            log("Deeplink detected", name: "CORE");
            if(uri != null) {
              if (uri.contains("bookmarks")) {
                tabController.index = 1;
              } else if (uri.contains("profile") && uri != RouteNames.editProfilePage) {
                tabController.index = 2;
              } else {
                Navigator.pushNamed(context, uri);
              }
            }
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    context.read<CurrentUserCubit>().getCurrentUserProfile();
                    context.read<UserBookmarksCubit>().loadBookmarkTitles(context);
                  }
                  return BlocBuilder<AllNewsCubit, AllNewsState>(
                    builder: (context, newsState) {
                      return Expanded(
                        child: TabBarView(controller: tabController, children: <Widget>[
                          if (newsState is AllNewsLoading) ...[
                            AllPageSkeleton(),
                          ],
                          if (newsState is AllNewsLoaded) ...[
                            AllPage(
                              allTopics: newsState.allTopics,
                            ),
                          ],
                          LandingBookmarkPage(),
                          LandingPageProfile()
                        ]),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: (_platform == TargetPlatform.android ? kBottomNavigationBarHeight : 49) + (bottomInsets ?? 0),
                child: TabBar(
                  controller: tabController,
                  onTap: (int index) {
                    if (!tabController.indexIsChanging && tabController.index == index && index == 0) {
                      context.read<TabsCubit>().changeTab('HOME');
                    }
                  },
                  tabs: myTabs,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorColor: Colors.transparent,
                  indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
                ),
              ),
              PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  final currentIndex = tabController.index;

                  if (currentIndex == 1 || currentIndex == 2) {
                    tabController.index = 0;
                  } else if (currentIndex == 0) {
                    SystemNavigator.pop();
                  }
                },
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
