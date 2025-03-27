import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/repository/news/news_interaction_repository.dart';

class AddOrRemoveBookmarkUsecase{
  final NewsInteractionRepository repository;

  AddOrRemoveBookmarkUsecase({required this.repository});

  Future<void> call(BookMarkItem bItem) async {
    return repository.addOrRemoveBookmark(bItem);
  }
}