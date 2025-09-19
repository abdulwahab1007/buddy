import 'package:flutter/material.dart';
import '../../Backend/api/chat_service.dart';
import '../../Models/chat_model.dart';


class MessageProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<Conversation> _conversations = [];
  int _unreadCount = 0;

  List<Conversation> get conversations => _conversations;
  int get unreadCount => _unreadCount;

  Future<void> loadConversations() async {
    _conversations = await _chatService.getConversations();
    _unreadCount = await _chatService.getUnreadCount();
    notifyListeners();
  }
}
