import 'package:startopreneur/domain/entities/channels/channels.dart';
import 'package:startopreneur/domain/repository/channels/channel_repository.dart';

class LoadAllChannelsUsecase{
  final ChannelRepository repository;

  LoadAllChannelsUsecase({required this.repository});

  Future<List<ChannelTopics>> call() async {
    return await repository.loadAllChannels();
  }
}