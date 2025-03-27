
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/channels/channels.dart';
import 'package:startopreneur/domain/usecases/channels/load_followed_channels_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'followed_channels_state.dart';

class FollowedChannelsCubit extends Cubit<FollowedChannelsState> {
  FollowedChannelsCubit() : super(FollowedChannelsLoading());

  Future<void> loadFollowedChannels() async {
    try {
      var result = await sl<LoadFollowedChannelsUsecase>().call();
      emit(FollowedChannelsLoaded(channelTopics: result));
    } catch (e) {
      log("Followed channel loading error: ${e.toString()}", name: 'CHANNELS');
    }
  }
}
