import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/repository/news/news_repository.dart';

class LoadOtherNewsUsecase{
  final NewsRepository repository;

  LoadOtherNewsUsecase({required this.repository});

  Future<List<BookMarkItem?>> call({required String topicName}){
    return repository.loadOtherNews(topicName: topicName);
  }
}