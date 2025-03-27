part of 'all_channels_cubit.dart';

sealed class AllChannelsState {}

final class AllChannelsLoading extends AllChannelsState {}
final class AllChannelsLoaded extends AllChannelsState {
  final List<ChannelTopics> channelTopics;
  final List<String> channelTitles;

  AllChannelsLoaded({required this.channelTopics, required this.channelTitles});
}
final class AllChannelsError extends AllChannelsState {}
