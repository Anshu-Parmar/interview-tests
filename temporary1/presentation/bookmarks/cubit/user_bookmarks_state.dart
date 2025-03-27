part of 'user_bookmarks_cubit.dart';

sealed class UserBookmarksState {}

final class UserBookmarksLoading extends UserBookmarksState {}

final class UserBookmarksLoaded extends UserBookmarksState {
  List<BookMarkItem?> bookmarkItem;
  Stream<List<String>> bookmarkTitles;

  UserBookmarksLoaded({required this.bookmarkItem, required this.bookmarkTitles});
}

final class UserBookmarksError extends UserBookmarksState {
  final String message;

  UserBookmarksError(this.message);
}
