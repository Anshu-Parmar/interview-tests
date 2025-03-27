import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startopreneur/data/sources/news/firebase_news_services.dart';
import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/repository/news/news_repository.dart';
import 'package:startopreneur/service_locator.dart';

class NewsRepositoryImpl extends NewsRepository{
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  NewsRepositoryImpl({
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<List<Channel?>> loadAllNews() async {
    return await sl<FirebaseNewsServices>().loadAllNews();
  }

  @override
  Future<List<BookMarkItem?>> loadOtherNews({required String topicName}) async {
    return await sl<FirebaseNewsServices>().loadOtherNews(topicName: topicName);
  }
}