import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/news/news_interactions/add_or_remove_bookmark_usecase.dart';
import 'package:startopreneur/service_locator.dart';

class CubitManager {
  static final CubitManager _instance = CubitManager._internal();

  factory CubitManager() => _instance;

  CubitManager._internal();

  final Map<String, AddOrRemoveBookmarkCubit> _cubitMap = {};

  AddOrRemoveBookmarkCubit getCubit(String bannerId) {
    return _cubitMap.putIfAbsent(bannerId, () => AddOrRemoveBookmarkCubit(bannerId));
  }
}

class AddOrRemoveBookmarkCubit extends Cubit<bool> {
  final String bannerId;

  AddOrRemoveBookmarkCubit(this.bannerId) : super(false);

  Future<void> toggleBookMark(BookMarkItem item) async {
    try {
      justToggleBookmark(!state);
      await sl<AddOrRemoveBookmarkUsecase>().call(item);
    } catch (e) {
      log(e.toString());
      justToggleBookmark(!state);
    }
  }

  void justToggleBookmark(bool isBookMarked) {
    emit(isBookMarked);
  }
}
