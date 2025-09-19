class NotificationItem {
  final String id;
  final String title;
  final String user;
  final String message;
  final String senderId;
  final String receiverId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.user,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'].toString(),
      title: _extractTitle(json['message'] ?? ''),
      user: json['sender_id'] ?? 'Unknown',
      message: json['message'] ?? '',
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      isRead: json['is_read'] == '1' || json['is_read'] == 1,
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  // Helper method to derive title from message
  static String _extractTitle(String message) {
    if (message.isEmpty) return 'Notification';
    // Example: Extract first part of message as title or use a static title
    return message.contains('Project details')
        ? 'New Order'
        : message.split('.').first;
  }
}
