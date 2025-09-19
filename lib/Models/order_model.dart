class Order {
  final String id;
  final String orderName;
  final String buyerName;
  final String profileImageUrl;
  final String description;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final List<Map<String, dynamic>> milestones;
  final List<Map<String, dynamic>> attachments;
  final bool isDelivered;
  final List<Map<String, dynamic>> deliveredFiles;

  Order({
    required this.id,
    required this.orderName,
    required this.buyerName,
    required this.profileImageUrl,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.milestones,
    required this.attachments,
    required this.isDelivered,
    required this.deliveredFiles,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      orderName: json['orderName'] ?? '',
      buyerName: json['buyerName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ??
          DateTime.now().add(const Duration(days: 7)),
      milestones: List<Map<String, dynamic>>.from(json['milestones'] ?? []),
      attachments: List<Map<String, dynamic>>.from(json['attachments'] ?? []),
      isDelivered: json['isDelivered'] ?? false,
      deliveredFiles:
          List<Map<String, dynamic>>.from(json['deliveredFiles'] ?? []),
    );
  }
}
