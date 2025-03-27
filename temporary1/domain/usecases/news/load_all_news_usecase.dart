import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/domain/repository/news/news_repository.dart';

class LoadAllNewsUsecase{
  final NewsRepository repository;

  LoadAllNewsUsecase({required this.repository});

  Future<List<Channel?>> call(){
    return repository.loadAllNews();
  }
}