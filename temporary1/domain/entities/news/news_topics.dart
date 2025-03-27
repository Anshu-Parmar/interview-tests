class NewsTopics {
  String topicId;
  final String title;
  String rss;

  NewsTopics({
    required this.topicId,
    required this.title,
    required this.rss
  });

  factory NewsTopics.fromSnapshot(Map<String, dynamic> snapshot, {required String topicId}) {
    return NewsTopics(
      topicId: topicId,
      title: snapshot['title'],
      rss: snapshot['rss'],
    );
  }
}