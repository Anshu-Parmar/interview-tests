class BookMarkItem {
  final String topicId;
  final String? title;
  final String? link;
  final String? channelTitle;
  final String? pubDate;
  final bool isBookmarked;
  final String? imageUrl;

  BookMarkItem(
      {required this.topicId, this.title, this.link, this.channelTitle, this.pubDate, this.imageUrl, required this.isBookmarked});

  factory BookMarkItem.fromSnapshot(Map<String, dynamic> snapshot, {required String topicId}) {
    return BookMarkItem(
      topicId: topicId,
      title: snapshot['title'],
      link: snapshot['link'],
      channelTitle: snapshot['channelTitle'],
      pubDate: snapshot['pubDate'],
      imageUrl: snapshot['imageUrl'],
      isBookmarked: snapshot['isBookMarked'] ?? false,
    );
  }
}
