class ChannelTopics {
  final String topicId;
  final String? title;
  final String? channelName;
  bool isFollowed;
  final bool isDefault;

  ChannelTopics({
    required this.topicId,
    this.title,
    this.channelName,
    this.isFollowed = false,
    this.isDefault = false
  });

  factory ChannelTopics.fromSnapshot(Map<String, dynamic> snapshot, {required String topicId, bool isFollowed = false}) {
    return ChannelTopics(
      topicId: topicId,
      title: snapshot['title'],
      channelName: snapshot['channelName'],
      isFollowed: isFollowed,
      isDefault: snapshot['isDefault'] ?? false
    );
  }
}