import 'package:startopreneur/domain/entities/channels/channels.dart';
import 'package:startopreneur/domain/repository/channels/channel_repository.dart';

class FollowUnfollowChannelsUsecase{
  final ChannelRepository repository;

  FollowUnfollowChannelsUsecase({required this.repository});

  Future<void> call({required ChannelTopics channelTopic}) async {
    return await repository.followUnfollowChannels(channelTopic: channelTopic);
  }
}