class Conversation {
  final int id;
  final String name;
  final String lastMessage;
  final String time;
  final String image;
  final int unread;
  final bool isOnline;

  Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.image,
    required this.unread,
    required this.isOnline,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'],
      lastMessage: json['last_message'] ?? '',
      time: json['time'] ?? '',
      image: "assets/avature.png", // fallback if no profile pic
      unread: json['unread'] ?? 0,
      isOnline: json['is_online'] ?? false,
    );
  }
}
