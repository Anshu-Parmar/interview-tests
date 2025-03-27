import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startopreneur/data/sources/news/firebase_news_interactions.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/repository/news/news_interaction_repository.dart';
import 'package:startopreneur/service_locator.dart';

class NewsInteractionRepositoryImpl extends NewsInteractionRepository{
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  NewsInteractionRepositoryImpl({
    required this.fireStore,
    required this.auth,
  });


  @override
  Future<void> addOrRemoveBookmark(BookMarkItem bItem) async {
    return await sl<FirebaseNewsInteractions>().addOrRemoveBookmark(bItem);
  }

  @override
  Stream<List<BookMarkItem?>?> loadBookmarks({int? limit, String? uid}) {
    return sl<FirebaseNewsInteractions>().loadBookmarks(limit: limit, uid: uid);
  }
}