import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/channels/channels.dart';
import 'package:startopreneur/domain/usecases/channels/load_all_channels_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'all_channels_state.dart';

class AllChannelsCubit extends Cubit<AllChannelsState> {
  AllChannelsCubit() : super(AllChannelsLoading());

  Future<void> loadAllChannels() async {
    try {
      var result = await sl<LoadAllChannelsUsecase>().call();
      var channelTitles = result.map((channel) => ("${channel.channelName} - (${channel.title?.toLowercaseWithCapitalFirst()})")).toList();
      emit(AllChannelsLoaded(channelTopics: result, channelTitles: channelTitles));
    } catch (e) {
      log(e.toString(), name: 'ALL-CHANNEL');
      rethrow;
    }
  }
}

extension TextFormatter on String {
  String toLowercaseWithCapitalFirst() {
    if (isEmpty) return this;
    final lowercased = toLowerCase();
    return lowercased[0].toUpperCase() + lowercased.substring(1);
  }
}