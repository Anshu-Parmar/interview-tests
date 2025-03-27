import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/news/load_other_news_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'funding_news_state.dart';

class FundingNewsCubit extends Cubit<FundingNewsState> {
  FundingNewsCubit() : super(FundingNewsLoading());

  Future<void> loadFundingNews() async {
    try {
      var result = await sl<LoadOtherNewsUsecase>().call(topicName: 'FUNDING');
      if(result.isEmpty) {
        emit(FundingNewsError(message: 'Empty'));
      } else {
        emit(FundingNewsLoaded(items: result));
      }
    } catch (e) {
      emit(FundingNewsError(message: e.toString()));
    }
  }
}
