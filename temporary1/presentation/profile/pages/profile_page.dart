import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/helper/short_name.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/presentation/channels/pages/channels_page.dart';
import 'package:startopreneur/presentation/profile/cubit/current_user_cubit.dart';
import 'package:startopreneur/presentation/profile/cubit/followed_channels_cubit.dart';
import 'package:startopreneur/presentation/profile/widget/profile_container_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<FollowedChannelsCubit>(
      create: (context) => FollowedChannelsCubit()..loadFollowedChannels(),
      child: BlocListener<CurrentUserCubit, CurrentUserState>(
          listener: (context, state) {},
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Account',
              actionIcon: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                    onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
                    icon: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          AppVectors.settings,
                          colorFilter: ColorFilter.mode(
                              context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor,
                              BlendMode.srcIn),
                        ))),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlocBuilder<CurrentUserCubit, CurrentUserState>(
                    builder: (context, state) {
                      if (state is CurrentUserLoaded) {
                        return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _bodyWidgets(state.currentUser)
                        );
                      }

                      if (state is CurrentUserLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ProfileContainerWidget(
                            user: null,
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: _lowerBodyWidget(context),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _bodyWidgets(UserEntity user) {
    return ProfileContainerWidget(
      user: user,
    );
  }

  Widget _lowerBodyWidget(BuildContext context) {
    return BlocBuilder<FollowedChannelsCubit, FollowedChannelsState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state is FollowedChannelsLoaded ? 'Following • ${state.channelTopics.length}' : 'Following • -',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.channelPage).then((value) async {
                        final bool? val = value as bool?;
                        if (val ?? false) {
                          isUpdate = false;
                          log("Updating followed news channels", name: 'CHANNELS');
                          await context.read<FollowedChannelsCubit>().loadFollowedChannels();
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        AppVectors.edit,
                        colorFilter: ColorFilter.mode(
                            context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor, BlendMode.srcIn),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (state is FollowedChannelsLoaded) ...[
              SizedBox(
                child: ListView.separated(
                  itemCount: state.channelTopics.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final channelTopic = state.channelTopics[index];
                    return ListTile(
                      minLeadingWidth: 4,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (channelTopic.channelName ?? "").toInitials(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: context.isDarkMode
                                  ? AppColors.lightBackgroundColor
                                  : AppColors.darkBackgroundColor
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      title: Text(channelTopic.channelName ?? ""),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                ),
              ),
            ],
            if (state is FollowedChannelsLoading) ...[
              Center(
                child: CircularProgressIndicator(),
              )
            ]
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
