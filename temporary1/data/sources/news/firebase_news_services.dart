import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:startopreneur/core/source/project_enums.dart';
import 'package:startopreneur/domain/entities/news/basic_news.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/entities/news/news_topics.dart';
import 'package:xml2json/xml2json.dart';

abstract class FirebaseNewsServices {
  Future<List<Channel?>> loadAllNews();

  Future<List<BookMarkItem?>> loadOtherNews({required String topicName});
}

class FirebaseNewsServicesImpl implements FirebaseNewsServices {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final client = http.Client();
  final Xml2Json xml2json = Xml2Json();

  FirebaseNewsServicesImpl({
    required this.fireStore,
    required this.auth,
  });


  @override
  Future<List<Channel?>> loadAllNews() async {
    final uid = auth.currentUser?.uid;
    var query = fireStore
        .collection(Collections.topics.collectionName)
        .where('isArchived', isEqualTo: false);

    try {
      var defaultTopics =  await query
          .where('isDefault', isEqualTo: true)
          .orderBy('title').get();

      int limit = 3;

      if (defaultTopics.docs.isEmpty) {
        return [];
      }

      List<NewsTopics> finalNews = defaultTopics.docs.map((doc) {
        return NewsTopics.fromSnapshot(
          doc.data(),
          topicId: doc.id,
        );
      }).toList();

      if(uid != null) {
        final unfollowedDefaultTopics = await fireStore
            .collection(Collections.unfollowed.collectionName)
            .where('userId', isEqualTo: uid)
            .get();

        if (unfollowedDefaultTopics.docs.isNotEmpty) {
          List<String> unFollowedTopicIds = unfollowedDefaultTopics.docs.map((doc) => doc['topicId'] as String).toList();

          final followedTopics = await fireStore
              .collection(Collections.followed.collectionName)
              .where('userId', isEqualTo: uid)
              .get();

          if(followedTopics.docs.isNotEmpty) {
            List<String> followedTopicIds = [];
            followedTopicIds = followedTopics.docs.map((doc) => doc['topicId'] as String).toList();

            final allNonDefaultTopics = await fireStore
                .collection(Collections.topics.collectionName)
                .where('isArchived', isEqualTo: false)
                .where('isDefault', isEqualTo: false)
                .where(FieldPath.documentId, whereIn: followedTopicIds)
                .get();

            if(allNonDefaultTopics.docs.isNotEmpty) {
              List<NewsTopics> allNonDefaultFollowedTopicsCollection = allNonDefaultTopics
                  .docs
                  .map((doc) => NewsTopics.fromSnapshot(doc.data(), topicId: doc.id)).toList();

              for(NewsTopics news in finalNews) {
                if(unFollowedTopicIds.contains(news.topicId)) {
                  String updateInTitle = news.title;
                  int topicLocation = allNonDefaultFollowedTopicsCollection.indexWhere((t) => t.title == updateInTitle);
                  if(topicLocation != -1) {
                    finalNews[topicLocation] = allNonDefaultFollowedTopicsCollection.where((val) => val.title == updateInTitle).first;
                  }
                }
              }
            }
          }

          for (String unfollowedId in unFollowedTopicIds) {
            finalNews.removeWhere((news) => news.topicId == unfollowedId);
          }
        }
      } else {
        print("GUEST");
      }

      List<Channel?> feeds = [];

      for (NewsTopics doc in finalNews) {
        final rssUrl = doc.rss;
        final response = await client.get(Uri.parse(rssUrl));

        if (response.statusCode == 200) {
          xml2json.parse(response.body);
          var jsonData = xml2json.toGData().replaceSymbols();
          Rss feed = Rss.fromJson(json.decode(jsonData), doc.topicId, limit: limit);
          feed.channel.description = doc.title;
          feeds.add(feed.channel);
        } else {
          log("Failed to load RSS feed from $rssUrl, status code: ${response.statusCode}", name: "NEWS");
        }
      }
      return feeds;

    } on FirebaseException catch (e) {
      log("Firebase exception: $e", name: "NEWS");
    } on SocketException catch (socket) {
      log("Internet error $socket", name: "NEWS");
    } catch (e) {
      log("Unexpected error: $e", name: "NEWS");
    }

    return [];
  }


  @override
  Future<List<BookMarkItem?>> loadOtherNews({required String topicName}) async {
    final uid = auth.currentUser?.uid;
    try {
      var query = fireStore.collection(Collections.topics.collectionName).where('isArchived', isEqualTo: false);

      if (uid != null) {
        final defaultSnapshot = await fireStore
            .collection('followed_topics')
            .where('userId', isEqualTo: 'default')
            .get();

        List<String> defaultTopicIds = defaultSnapshot.docs.map((doc) => doc['topicId'] as String).toList();

        final unfollowedDefaultTopics = await fireStore
            .collection(Collections.unfollowed.collectionName)
            .where('userId', isEqualTo: uid)
            .get();

        if(unfollowedDefaultTopics.docs.isNotEmpty) {
          List<String> unFollowedTopicIds = unfollowedDefaultTopics.docs.map((doc) => doc['topicId'] as String).toList();

          for(String unFollowedTopicId in unFollowedTopicIds) {
            defaultTopicIds.remove(unFollowedTopicId);
          }
        }

        final followedSnapshot = await fireStore
            .collection('followed_topics')
            .where('userId', isEqualTo: uid)
            .get();

        List<String> followedTopicIds = followedSnapshot
            .docs
            .map((doc) => doc['topicId'] as String)
            .toList();

        followedTopicIds.addAll(defaultTopicIds);
        query = query
            .where(FieldPath.documentId, whereIn: followedTopicIds.isNotEmpty
              ? followedTopicIds
              : ['none']
        );

      } else {
        query = query.where('isDefault', isEqualTo: true);
      }


      final snapshot = await query.where('title', isEqualTo: topicName).get();

      int limit = 10;

      if (snapshot.docs.isEmpty) {
        return [];
      }

      final List<BookMarkItem> bookmarkItems = [];

      for (var doc in snapshot.docs) {
        final rssUrl = doc.data()['rss'];

        final response = await client.get(Uri.parse(rssUrl));

        if (response.statusCode == 200) {
          xml2json.parse(response.body);
          var jsonData = xml2json.toGData().replaceSymbols();
          final Rss feed = Rss.fromJson(json.decode(jsonData), doc.id, limit: limit);

          final channel = feed.channel;

          for (var item in channel.items) {
            bookmarkItems.add(BookMarkItem(
              topicId: channel.topicId,
              title: item.title,
              link: item.link,
              channelTitle: channel.title,
              pubDate: item.pubDate,
              isBookmarked: false,
              imageUrl: item.content?.url,
            ));
          }
        } else {
          log("Failed to load RSS feed, status code (${doc.id}): ${response.statusCode}", name: "NEWS");
        }
      }

      bookmarkItems.sort((a, b) {
        final dateA = DateFormat("dd/MM/yyyy").parse(a.pubDate!);
        final dateB = DateFormat("dd/MM/yyyy").parse(b.pubDate!);
        return dateB.compareTo(dateA);
      });

      return bookmarkItems;

    } on FirebaseException catch (e) {
      log("Firebase exception ($topicName): $e", name: "NEWS");
      rethrow;
    } on SocketException catch (socket) {
      log("Internet error ($topicName): $socket", name: "NEWS");
      rethrow;
    } catch (e) {
      log("Unexpected error ($topicName): $e", name: "NEWS");
      rethrow;
    }
  }
}

extension SymbolReplacement on String {
  String replaceSymbols() {

    return replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '\'')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('â', "'")
        .replaceAll('â', "'")
        .replaceAll('â¦', '…');
  }
}