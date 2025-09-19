import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/chat_model.dart';


class ChatService {
  final String baseUrl = "http://127.0.0.1:8000/api";
  final String token = "YOUR_BEARER_TOKEN"; // replace with auth token

  Future<List<Conversation>> getConversations() async {
    final response = await http.get(
      Uri.parse("$baseUrl/chat/conversations"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Conversation.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load conversations");
    }
  }

  Future<int> getUnreadCount() async {
    final response = await http.get(
      Uri.parse("$baseUrl/chat/unread-count"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unread_count'] ?? 0;
    } else {
      return 0;
    }
  }
}
