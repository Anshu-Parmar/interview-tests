import 'dart:developer';

import 'package:intl/intl.dart';

bool check = true;

class Rss {
  final Channel channel;

  Rss({required this.channel});

  factory Rss.fromJson(Map<String, dynamic> json, String topicId, {int? limit}) {
    try{
      return Rss(
        channel: Channel.fromJson(json['rss']['channel'], topicId, limit: limit),
      );
    } catch (e) {
      log(e.toString(), name: 'RSS');
      rethrow;
    }
  }
}

class Channel {
  final String title;
  String description;
  final String language;
  final String lastBuildDate;
  final List<Item> items;
  final String topicId;

  Channel({
    required this.topicId,
    required this.title,
    required this.description,
    required this.language,
    required this.lastBuildDate,
    required this.items,
  });

  factory Channel.fromJson(Map<String, dynamic> json, String topicId, {int? limit}) {

    try{
      List<dynamic> itemList = json['item'] as List<dynamic>? ?? [];
      List<Item> itemsList = limit != null
          ? itemList.take(limit).map((itemJson) => Item.fromJson(itemJson)).toList()
          : itemList.map((itemJson) => Item.fromJson(itemJson)).toList();

      itemsList.sort((a, b) {
        final dateA = DateFormat("dd/MM/yyyy").parse(a.pubDate);
        final dateB = DateFormat("dd/MM/yyyy").parse(b.pubDate);
        return dateB.compareTo(dateA);
      });

      ///TO TEST NEW RSS
      // print(json['title']?['\$t'] ?? json['title']?['__cdata'] ?? '');
      // print(json['description']?['\$t'] ?? '');
      // print(json['language']?['\$t'] ?? 'en-US');
      // print((json['lastBuildDate']?['\$t'] ?? json['lastBuildDate']).toString().toCustomDateFormat());


      return Channel(
        topicId: topicId,
        title: json['title']?['\$t'] ?? json['title']?['__cdata'] ?? '',
        description: json['description']?['\$t'] ?? '',
        language: json['language']?['\$t'] ?? 'en-US',
        lastBuildDate: (json['lastBuildDate']?['\$t'] ?? json['lastBuildDate']).toString().toCustomDateFormat(),
        items: itemsList,
      );
    } catch (e) {
      log(e.toString(), name: 'CHANNEL');
      rethrow;
    }
  }
}

class Item {
  final String title;
  final String link;
  final String description;
  final String pubDate;
  final Content? content;

  Item({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    required this.content,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    ///TO TEST NEW RSS
    // print(json['title']?['\$t'] ?? json['title']?['__cdata'] ?? '');
    // print(json['link']?['\$t'] ?? json['link']?['__cdata'] ?? '');
    // print(json['description']?['\$t'] ?? json['description']?['__cdata'] ?? '');
    // print((json['pubDate']?['\$t'] ?? json['pubDate']).toString().toCustomDateFormat());
    // print(json['media\$content'] != null || json['media\$thumbnail'] != null || json['enclosure\$url'] != null
    //     ? Content.fromJson(json['media\$content'] ?? json['media\$thumbnail'] ?? json['enclosure'])
    //     : null);
    try {
      return Item(
          title: json['title']?['\$t'] ?? json['title']?['__cdata'] ?? '',
          link: json['link']?['\$t'] ?? json['link']?['__cdata'] ?? json['link'],
          description: json['description']?['\$t'] ?? json['description']?['__cdata'] ?? json['description'] ?? '',
          pubDate: (json['pubDate']?['\$t'] ?? json['pubDate']?['__cdata'] ?? json['pubDate']).toString().toCustomDateFormat(),
          content: json['media\$content'] != null || json['media\$thumbnail'] != null || json['enclosure'] != null
              ? Content.fromJson(json['media\$content'] ?? json['media\$thumbnail'] ?? json['enclosure'])
              : null,
      );
    } catch (e) {
      log(e.toString(), name: 'ITEMS');
      rethrow;
    }
  }
}

class Content {
  final String url;
  final int? width;
  final int? height;

  Content({
    required this.url,
    this.width,
    this.height,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    try {
      return Content(
        url: json['url'] ?? json['_url'] ,
      );
    } catch (e) {
      rethrow;
    }
  }
}


extension DateFormatExtension on String {
  String toCustomDateFormat() {
    try {
      final inputFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z", 'en_US');
      final dateTime = inputFormat.parse(this);
      final outputFormat = DateFormat("dd/MM/yyyy");
      return outputFormat.format(dateTime);
    } catch (e) {
      return 'Invalid date format';
    }
  }
}