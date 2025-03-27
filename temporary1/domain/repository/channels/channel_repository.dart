import 'package:startopreneur/domain/entities/channels/channels.dart';

abstract class ChannelRepository {
  Future<List<ChannelTopics>> loadFollowedChannels();

  Future<List<ChannelTopics>> loadAllChannels();

  Future<void> followUnfollowChannels({required ChannelTopics channelTopic});
}
