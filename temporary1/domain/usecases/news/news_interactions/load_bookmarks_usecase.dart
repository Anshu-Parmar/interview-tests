import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/repository/news/news_interaction_repository.dart';

class LoadBookmarksUsecase{
  final NewsInteractionRepository repository;

  LoadBookmarksUsecase({required this.repository});

  Stream<List<BookMarkItem?>?> call({int? limit, String? uid}) {
    return repository.loadBookmarks(limit: limit, uid: uid);
  }
}