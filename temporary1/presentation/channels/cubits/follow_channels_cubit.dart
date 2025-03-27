import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/channels/channels.dart';
import 'package:startopreneur/domain/usecases/channels/follow_unfollow_channels_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'follow_channels_state.dart';

class FollowChannelsCubit extends Cubit<FollowChannelsState> {
  FollowChannelsCubit(List<ChannelTopics> initialTopics)
      : super(FollowChannelsState(channelTopics: initialTopics));

  Future<void> toggleFollow(int index) async {
    final updatedTopics = List<ChannelTopics>.from(state.channelTopics);
    updatedTopics[index].isFollowed = !updatedTopics[index].isFollowed;
    emit(state.copyWith(channelTopics: updatedTopics));
    try {
      await sl<FollowUnfollowChannelsUsecase>().call(channelTopic: updatedTopics[index]);
    } catch (e) {
      emit(state.copyWith(channelTopics: state.channelTopics));
    }
  }
}