import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/news/load_other_news_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'productivity_news_state.dart';

class ProductivityNewsCubit extends Cubit<ProductivityNewsState> {
  ProductivityNewsCubit() : super(ProductivityNewsLoading());

  Future<void> loadProductivityNews() async {
    try {
      var result = await sl<LoadOtherNewsUsecase>().call(topicName: 'PRODUCTIVITY');
      if(result.isEmpty) {
        emit(ProductivityNewsError(message: 'Empty'));
      } else {
        emit(ProductivityNewsLoaded(items: result));
      }

    } catch (e) {
      emit(ProductivityNewsError(message: e.toString()));
    }
  }
}
