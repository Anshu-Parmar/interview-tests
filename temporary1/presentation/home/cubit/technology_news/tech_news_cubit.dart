import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/news/load_other_news_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'tech_news_state.dart';

class TechNewsCubit extends Cubit<TechNewsState> {
  TechNewsCubit() : super(TechNewsLoading());

  Future<void> loadTechNews() async {
    try {
      var result = await sl<LoadOtherNewsUsecase>().call(topicName: 'TECHNOLOGY');
      if(result.isEmpty) {
        emit(TechNewsError(message: 'Empty'));
      } else {
        emit(TechNewsLoaded(items: result));
      }
    } catch (e) {
      emit(TechNewsError(message: e.toString()));
    }
  }
}
