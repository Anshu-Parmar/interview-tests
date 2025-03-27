import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/news/load_other_news_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'management_news_state.dart';

class ManagementNewsCubit extends Cubit<ManagementNewsState> {
  ManagementNewsCubit() : super(ManagementNewsLoading());

  Future<void> loadManagementNews() async {
    try {
      var result = await sl<LoadOtherNewsUsecase>().call(topicName: 'MANAGEMENT');
      if(result.isEmpty) {
        emit(ManagementNewsError(message: 'Empty'));
      } else {
        emit(ManagementNewsLoaded(items: result));
      }
    } catch (e) {
      emit(ManagementNewsError(message: e.toString()));
    }
  }
}
