part of 'follow_channels_cubit.dart';

class FollowChannelsState {
  final List<ChannelTopics> channelTopics;

  FollowChannelsState({required this.channelTopics});

  FollowChannelsState copyWith({List<ChannelTopics>? channelTopics}) {
    return FollowChannelsState(
      channelTopics: channelTopics ?? this.channelTopics,
    );
  }
}