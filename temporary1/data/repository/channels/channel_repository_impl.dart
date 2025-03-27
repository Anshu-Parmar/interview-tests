import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startopreneur/data/sources/channel/firebase_channels_services.dart';
import 'package:startopreneur/domain/entities/channels/channels.dart';
import 'package:startopreneur/domain/repository/channels/channel_repository.dart';
import 'package:startopreneur/service_locator.dart';

class ChannelRepositoryImpl extends ChannelRepository{
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  ChannelRepositoryImpl({
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<List<ChannelTopics>> loadFollowedChannels() async  {
    return await sl<FirebaseChannelsServices>().loadFollowedChannels();
  }

  @override
  Future<List<ChannelTopics>> loadAllChannels() async  {
    return await sl<FirebaseChannelsServices>().loadAllChannels();
  }

  @override
  Future<void> followUnfollowChannels({required ChannelTopics channelTopic}) async  {
    return await sl<FirebaseChannelsServices>().followUnfollowChannels(channelTopic: channelTopic);
  }
}
