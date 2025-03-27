import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';

abstract class NewsRepository {
  Future<List<Channel?>> loadAllNews();

  Future<List<BookMarkItem?>> loadOtherNews({required String topicName});
}