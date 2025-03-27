import 'package:startopreneur/domain/entities/news/book_mark_news.dart';

abstract class NewsInteractionRepository {
  Future<void> addOrRemoveBookmark(BookMarkItem bItem);

  Stream<List<BookMarkItem?>?> loadBookmarks({int? limit, String? uid});
}