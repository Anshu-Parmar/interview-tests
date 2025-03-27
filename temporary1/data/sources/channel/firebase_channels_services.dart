import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startopreneur/core/source/project_enums.dart';
import 'package:startopreneur/domain/entities/channels/channels.dart';

abstract class FirebaseChannelsServices {
  Future<List<ChannelTopics>> loadFollowedChannels();

  Future<List<ChannelTopics>> loadAllChannels();

  Future<void> followUnfollowChannels({required ChannelTopics channelTopic});
}

class FirebaseChannelsServicesImpl implements FirebaseChannelsServices {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  FirebaseChannelsServicesImpl({required this.fireStore, required this.auth});

  @override
  Future<List<ChannelTopics>> loadFollowedChannels() async {
    final uid = auth.currentUser?.uid;

    try {
      var data3 = await fireStore
          .collection(Collections.unfollowed.collectionName)
          .where('userId', isEqualTo: uid)
          .get();

      var data = await fireStore
          .collection(Collections.topics.collectionName)
          .where('isArchived', isEqualTo: false)
          .where('isDefault', isEqualTo: true)
          .get();

      var data2 = await fireStore
          .collection(Collections.followed.collectionName)
          .where('userId', isEqualTo: uid)
          .get();

      final Set<String?> uniqueChannelNames = <String?>{};

      final List<ChannelTopics> combinedChannels = [];

      final channelsFromTopics = data.docs.map((doc) {
        return ChannelTopics.fromSnapshot(
          doc.data(),
          topicId: doc.id,
        );
      }).toList();
      // .where((channel) {
      //   final isNew = uniqueChannelNames.add(channel.channelName ?? "");
      //   return isNew;
      // }).toList();

      if(data3.docs.isNotEmpty) {
        try{
          var unFollowedTopicIds = data3.docs.map((doc) => doc['topicId'] as String).toList();
          channelsFromTopics.removeWhere((topics) => unFollowedTopicIds.contains(topics.topicId),);
        } catch (e) {
          log("Error in loading default unfollowed topics.", name:'CHANNELS');
        }
      }

      if(channelsFromTopics.isNotEmpty) {
        for(var v in channelsFromTopics) {
          uniqueChannelNames.add(v.channelName);
        }
        combinedChannels.addAll(channelsFromTopics);
      }
      if(data2.docs.isNotEmpty) {
        final followedTopicIds = data2.docs.map((doc) => doc['topicId'] as String).toList();

        var topicsQuerySnapshot = await fireStore
            .collection(Collections.topics.collectionName)
            .where('isArchived', isEqualTo: false)
            .where(FieldPath.documentId, whereIn: followedTopicIds)
            .get();

        final channelsFromFollowedTopics = topicsQuerySnapshot.docs.map((doc) {
          return ChannelTopics.fromSnapshot(
            doc.data(),
            topicId: doc.id,
          );
        }).where((channel) {
          final isNew = uniqueChannelNames.add(channel.channelName ?? "");
          return isNew;
        }).toList();

        combinedChannels.addAll(channelsFromFollowedTopics);
      }
      return combinedChannels;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChannelTopics>> loadAllChannels() async {
    final uid = auth.currentUser?.uid;

    try {
      var data3 = await fireStore
          .collection(Collections.unfollowed.collectionName)
          .where('userId', isEqualTo: uid)
          .get();

      var unFollowedTopicIds = [];

      if(data3.docs.isNotEmpty) {
        unFollowedTopicIds = data3.docs.map((doc) => doc['topicId'] as String).toList();
      }

      var data = await fireStore
          .collection(Collections.topics.collectionName)
          .orderBy('createdAt', descending: true)
          .where('isArchived', isEqualTo: false)
          .get();

      var data2 = await fireStore
          .collection(Collections.followed.collectionName)
          .where('userId', isEqualTo: uid)
          .get();

      final uniqueChannelNames = <String>{};

      var channels = data.docs.map((doc) {
        return ChannelTopics.fromSnapshot(
          doc.data() ,
          topicId: doc.id,
          isFollowed: doc.data()['isDefault'] && !unFollowedTopicIds.contains(doc.id)
        );
      }).where((channel) {
        final isNew = uniqueChannelNames.add("${channel.channelName} - (${channel.title})");
        return isNew;
      }).toList();

      if(data2.docs.isNotEmpty) {
        final followedTopicIds = data2.docs.map((doc) => doc['topicId'] as String).toList();

        var topicsQuerySnapshot = await fireStore
            .collection(Collections.topics.collectionName)
            .where('isArchived', isEqualTo: false)
            .where('isDefault', isEqualTo: false)
            .where(FieldPath.documentId, whereIn: followedTopicIds)
            .get();

        for (var doc in topicsQuerySnapshot.docs) {
          final topicId = doc.id;
          final index = channels.indexWhere((channel) => channel.topicId == topicId,);
          channels[index].isFollowed = true;
        }
      }

      return channels;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> followUnfollowChannels({required ChannelTopics channelTopic}) async {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      return;
    }

    if(channelTopic.isDefault) {
      try {
        var collectionSnap = fireStore.collection(Collections.unfollowed.collectionName);
        var querySnapshot = await collectionSnap
            .where('userId', isEqualTo: uid)
            .where('topicId', isEqualTo: channelTopic.topicId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.delete();
        } else {
          await collectionSnap.add({
            'topicId': channelTopic.topicId,
            'userId': uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        log("Default followed topics action error", name: 'CHANNELS');
        rethrow;
      }
    } else {
      try {
        var collectionSnap = fireStore.collection(Collections.followed.collectionName);
        var querySnapshot = await collectionSnap
            .where('userId', isEqualTo: uid)
            .where('topicId', isEqualTo: channelTopic.topicId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.delete();
        } else {
          await collectionSnap.add({
            'topicId': channelTopic.topicId,
            'userId': uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        log("Followed topics action error", name: 'CHANNELS');
        rethrow;
      }
    }
  }
}