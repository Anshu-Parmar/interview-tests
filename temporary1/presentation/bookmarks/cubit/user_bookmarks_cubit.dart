import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/news/news_interactions/load_bookmarks_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'user_bookmarks_state.dart';

class UserBookmarksCubit extends Cubit<UserBookmarksState> {
  UserBookmarksCubit() : super(UserBookmarksLoading());

  final StreamController<List<String>> _bookmarkTitlesController = StreamController<List<String>>.broadcast();

  Stream<List<String>> get bookmarkTitles => _bookmarkTitlesController.stream;
  StreamSubscription<List<BookMarkItem?>?>? _subscription;
  List<String> _currentTitles = [];

  Future<void> loadBookmarkTitles(BuildContext context) async {
    try {
      emit(UserBookmarksLoading());
      _subscription = sl<LoadBookmarksUsecase>().call().listen((bookmarks) {
          _currentTitles = bookmarks?.map((item) => item?.title ?? "").toList() ?? [];
          _bookmarkTitlesController.add(_currentTitles);
          emit(UserBookmarksLoaded(bookmarkItem: bookmarks ?? [], bookmarkTitles: bookmarkTitles));
        },
        onError: (error) {
          emit(UserBookmarksError(error.toString()));
        },
      );
    } catch (e) {
      log(e.toString());
      emit(UserBookmarksError(e.toString()));
    }
  }

  void addBookmarkTitle(String title) {
    _currentTitles.add(title);
    _bookmarkTitlesController.add(List<String>.from(_currentTitles));
  }

  void removeBookmarkTitle(String title) {
    _currentTitles.removeWhere((name) => name == title);
    _bookmarkTitlesController.add(List<String>.from(_currentTitles));
  }

  bool checkBookmarkTitleHas(String title) {
    return _currentTitles.contains(title);
  }

  // @override
  Future<void> closeStream() async {
    emit(UserBookmarksLoading());
    _subscription?.cancel();
    _bookmarkTitlesController.close();
  }
}
