part of 'followed_channels_cubit.dart';

sealed class FollowedChannelsState {}

final class FollowedChannelsLoading extends FollowedChannelsState {}
final class FollowedChannelsLoaded extends FollowedChannelsState {
  final List<ChannelTopics> channelTopics;

  FollowedChannelsLoaded({required this.channelTopics});
}
final class FollowedChannelsError extends FollowedChannelsState {}
