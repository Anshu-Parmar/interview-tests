import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/helper/short_name.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/channels/channels.dart';
import 'package:startopreneur/presentation/channels/cubits/all_channels_cubit.dart';
import 'package:startopreneur/presentation/channels/cubits/follow_channels_cubit.dart';
import 'package:startopreneur/presentation/channels/cubits/search_cubit.dart';

bool isUpdate = false;

class ChannelPage extends StatelessWidget {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllChannelsCubit()..loadAllChannels(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, result) {
          if (didPop) {
            return;
          }
          final bool shouldPop = true;
          if (context.mounted && shouldPop) {
            Navigator.pop(context, isUpdate);
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Following',
            showBackButton: true,
            onTapLeading: () => Navigator.pop(context, isUpdate),
          ),
          body: BlocBuilder<AllChannelsCubit, AllChannelsState>(
            builder: (context, channelState) {
              if (channelState is AllChannelsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (channelState is AllChannelsLoaded) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => SearchCubit(channelState.channelTitles)),
                    BlocProvider(create: (_) => FollowChannelsCubit(channelState.channelTopics)),
                  ],
                  child: Scaffold(
                    appBar: AppBar(
                      title: SearchBar(),
                      leading: const SizedBox(),
                      leadingWidth: 0,
                    ),
                    body: BlocBuilder<SearchCubit, List<String>>(
                      builder: (context, filteredItems) {
                        if (filteredItems.isEmpty) {
                          return const Center(
                            child: Text('No Results Found', style: TextStyle(fontSize: 18)),
                          );
                        }

                        return BlocBuilder<FollowChannelsCubit, FollowChannelsState>(
                          builder: (context, followState) {
                            final followedItems = _getItems(filteredItems, followState.channelTopics, true);
                            final nonFollowedItems = _getItems(filteredItems, followState.channelTopics, false);

                            return ListView.separated(
                              itemCount: followedItems.length + nonFollowedItems.length + 1,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                if (index == followedItems.length) {
                                  return const Divider();
                                }

                                final isFollowed = index < followedItems.length;
                                final name = isFollowed ? followedItems[index] : nonFollowedItems[index - followedItems.length - 1];

                                return ChannelListTile(name: name, isFollowed: isFollowed, followedListLength: followedItems.length);
                              },
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }

              if (channelState is AllChannelsError) {
                return const Center(child: Text('Error loading channels'));
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  List<String> _getItems(List<String> filteredItems, List<ChannelTopics> channelTopics, bool isFollowed) {
    ///to compare anything in channel topics, use the following format as it is used in channel pages
    ///$channelName - ${title.toLowercaseWithCapitalFirst()} or you can change all to lowercase
    ///just like i have done below
    return filteredItems.where((name) {
      final index = channelTopics.indexWhere((topic) {
        final chanelName = "${topic.channelName?.toLowerCase()} - (${topic.title?.toLowerCase()})";
        return chanelName == name.toLowerCase();
      });
      return channelTopics[index].isFollowed == isFollowed;
    }).toList();
    // return filteredItems
    //     .asMap()
    //     .entries
    //     .where((entry) => channelTopics[entry.key].isFollowed == isFollowed)
    //     .map((entry) => entry.value)
    //     .toList();
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, List<String>>(
      builder: (context, _) {
        return TextField(
          controller: _textEditingController,
          autofocus: false,
          onChanged: (value) => context.read<SearchCubit>().search(value),
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(
              Icons.search,
            ),
            suffixIcon: InkWell(
              onTap: () => _textEditingController.clear(),
              child: Icon(
                  Icons.close
              ),
            )
          ),
        );
      },
    );
  }
}

class ChannelListTile extends StatelessWidget {
  final String name;
  final bool isFollowed;
  final int followedListLength;

  const ChannelListTile({super.key, required this.name, required this.isFollowed, required this.followedListLength});

  @override
  Widget build(BuildContext context) {
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
          name.toInitials(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      trailing: TextButton(
        onPressed: () {
          final cubit = context.read<FollowChannelsCubit>();
          final index = cubit.state.channelTopics.indexWhere((topic) => "${topic.channelName} - (${topic.title?.toLowercaseWithCapitalFirst()})" == name);

          if (index != -1 && (followedListLength > 1 || !isFollowed)) {
            _showUnfollowDialog(context, channelName: name, isFollowed: isFollowed, cubit: cubit, index: index);
          } else if (cubit.state.channelTopics.length > 1) {
            log("At least 1 channel required!!", name: 'CHANNELS');
            SnackBarDisplay(
              context: context,
              message: 'Cannot unfollow all channels. At least one channel is required!',
              time: 2500,
            ).showSnackBar();
          } else {
            log("Follow/Unfollow unknown error!!", name: 'CHANNELS');
            SnackBarDisplay(
              context: context,
              message: 'This action cannot be performed at this moment!!',
              time: 2500,
            ).showSnackBar();
          }

          service.HapticFeedback.mediumImpact();

          // if (index != -1 && !cubit.state.channelTopics[index].isDefault) {
          //   isUpdate = true;
          //   cubit.toggleFollow(index);
          // } else {
          //   SnackBarDisplay(
          //     context: context,
          //     message: 'This action cannot be performed!!',
          //   ).showSnackBar();
          // }
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: isFollowed
                  ? AppColors.primaryColor
                  : context.isDarkMode
                      ? AppColors.lightBackgroundColor
                      : AppColors.darkBackgroundColor,
            ),
          ),
        ),
        child: Text(
          isFollowed ? 'Following' : 'Follow',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isFollowed
                ? AppColors.primaryColor
                : context.isDarkMode
                    ? AppColors.lightBackgroundColor
                    : AppColors.darkBackgroundColor,
          ),
        ),
      ),
    );
  }

  void _showUnfollowDialog(BuildContext context, {
    required String channelName,
    required bool isFollowed,
    required FollowChannelsCubit cubit,
    required int index
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${isFollowed ? "UNFOLLOW" : "FOLLOW"} - $channelName', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
          content: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyle(
                color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor,
                height: 1.3
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Are you sure you want to',
                ),
                TextSpan(
                  text: ' ${isFollowed ? "Unfollow" : "Follow"} - $channelName ? ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '\nYou can ${isFollowed ? "follow" : "unfollow"} the channel again anytime.',
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
                isFollowed ? 'UnFollow' : 'Follow',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isFollowed ? Colors.red : AppColors.primaryColor),
              ),
              onPressed: () {
                isUpdate = true;
                cubit.toggleFollow(index);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
