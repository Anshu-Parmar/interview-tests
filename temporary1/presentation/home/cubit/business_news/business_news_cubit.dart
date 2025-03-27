import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/news/load_other_news_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'business_news_state.dart';

class BusinessNewsCubit extends Cubit<BusinessNewsState> {
  BusinessNewsCubit() : super(BusinessNewsLoading());

  Future<void> loadBusinessNews() async {
    try {
      var result = await sl<LoadOtherNewsUsecase>().call(topicName: 'BUSINESS');
      if(result.isEmpty) {
        emit(BusinessNewsError(message: 'Empty'));
      } else {
        emit(BusinessNewsLoaded(items: result));
      }
    } catch (e) {
      emit(BusinessNewsError(message: e.toString()));
    }
  }
}
