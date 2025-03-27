import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';

abstract class FirebaseNewsInteractions {
  Future<void> addOrRemoveBookmark(BookMarkItem bItem);

  Stream<List<BookMarkItem?>?> loadBookmarks({int? limit, String? uid});
}

class FirebaseNewsInteractionsImpl implements FirebaseNewsInteractions {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  FirebaseNewsInteractionsImpl({required this.fireStore, required this.auth});

  @override
  Future<void> addOrRemoveBookmark(BookMarkItem bItem) async {
    try {
      final uid = auth.currentUser?.uid;

      await fireStore.runTransaction((transaction) async {
        final userBookmarkCollection = fireStore.collection('bookmarks');

        var bookMarkDocs = await userBookmarkCollection
            .where('uid', isEqualTo: uid)
            .where('title', isEqualTo: bItem.title)
            .get();

        if (bItem.isBookmarked) {
          DocumentReference newDocRef;
          if(bookMarkDocs.docs.isNotEmpty) {
            newDocRef = bookMarkDocs.docs.first.reference;
          } else {
            newDocRef = userBookmarkCollection.doc();
          }
          transaction.set(
              newDocRef,
              {
                'uid': uid,
                'topicId': bItem.topicId,
                'title': bItem.title,
                'channelTitle': bItem.channelTitle,
                'pubDate': bItem.pubDate,
                'imageUrl': bItem.imageUrl,
                'link': bItem.link,
                'isBookMarked': true,
                'createdAt': FieldValue.serverTimestamp()
              },
              SetOptions(merge: true));
          log("Bookmark added!", name: 'BOOKMARKS');
        } else {
          DocumentReference delDoc = bookMarkDocs.docs.first.reference;
          transaction.delete(delDoc);
          log("Bookmark deleted!", name: 'BOOKMARKS');
        }
      });
    } on FirebaseException catch (e) {
      log("FirebaseError - ${e.message}", name: 'BOOKMARKS');
    } catch (e) {
      log("CodeError - ${e.toString()}", name: 'BOOKMARKS');
    }
  }

  @override
  Stream<List<BookMarkItem?>?> loadBookmarks({int? limit, String? uid}) {
    final uid = auth.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('topics')
        .where('isArchived', isEqualTo: false)
        .get()
        .asStream()
        .asyncExpand((topicsSnapshot) {
      final validTopics = topicsSnapshot.docs.map((doc) => doc.id).toSet();

      var query = fireStore
          .collection('bookmarks')
          .orderBy('createdAt', descending: true)
          .where('uid', isEqualTo: uid)
          .where('isBookMarked', isEqualTo: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().map((bookmarkSnapshot) {
        return bookmarkSnapshot.docs
            .map((doc) {
              final data = doc.data();
              final topicId = data['topicId'];

              if (validTopics.contains(topicId)) {
                return BookMarkItem.fromSnapshot(data, topicId: topicId);
              }
              return null;
            })
            .where((bookmark) => bookmark != null)
            .cast<BookMarkItem>()
            .toList();
      });
    });
  }
}
