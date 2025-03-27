import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/domain/usecases/news/load_all_news_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'all_news_state.dart';

class AllNewsCubit extends Cubit<AllNewsState> {
  AllNewsCubit() : super(AllNewsInitial());

  Future<void> loadAllNews() async {
    emit(AllNewsLoading());
    try {
      var result = await sl<LoadAllNewsUsecase>().call();
      emit(AllNewsLoaded(allTopics: result));
    } catch (e) {
      log(e.toString(), name: 'ALL-NEWS');
      emit(AllNewsFailure(message: e.toString()));
    }
  }
}
