import '../api_service.dart';

/// Comprehensive Chat API Service
/// Handles all chat-related API calls from the Postman collection
class ChatApiService {
  
  /// Send chat message
  /// POST /api/realtime-chat/send
  static Future<Map<String, dynamic>> sendChatMessage({
    required int conversationId,
    required String message,
  }) async {
    try {
      return await ApiService.post('/realtime-chat/send', body: {
        'conversation_id': conversationId,
        'message': message,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send message: $e',
        'statusCode': 500,
      };
    }
  }

  /// Send chat with gig context
  /// POST /api/realtime-chat/send
  static Future<Map<String, dynamic>> sendChatWithGig({
    required int gigId,
    required int senderId,
    required int receiverId,
    required String chat,
  }) async {
    try {
      return await ApiService.post('/realtime-chat/send', body: {
        'gig_id': gigId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'chat': chat,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send chat: $e',
        'statusCode': 500,
      };
    }
  }

  /// Mark message as read
  /// PUT /api/chat/messages/read/{conversationId}
  static Future<Map<String, dynamic>> markMessageAsRead(int conversationId) async {
    try {
      return await ApiService.put('/chat/messages/read/$conversationId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to mark message as read: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get unread message count
  /// GET /api/chat/unread-count
  static Future<Map<String, dynamic>> getUnreadCount() async {
    try {
      return await ApiService.get('/chat/unread-count');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get unread count: $e',
        'statusCode': 500,
      };
    }
  }

  /// Archive conversation
  /// PUT /api/chat/archive/{conversationId}
  static Future<Map<String, dynamic>> archiveConversation(int conversationId) async {
    try {
      return await ApiService.put('/chat/archive/$conversationId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to archive conversation: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete conversation
  /// DELETE /api/chat/delete/{conversationId}
  static Future<Map<String, dynamic>> deleteConversation(int conversationId) async {
    try {
      return await ApiService.delete('/chat/delete/$conversationId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete conversation: $e',
        'statusCode': 500,
      };
    }
  }

  /// Start conversation from gig
  /// POST /api/chat/start/{gigId}
  static Future<Map<String, dynamic>> startConversationFromGig(int gigId) async {
    try {
      return await ApiService.post('/chat/start/$gigId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to start conversation: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get all conversations
  /// GET /api/chat/conversations
  static Future<Map<String, dynamic>> getAllConversations() async {
    try {
      return await ApiService.get('/chat/conversations');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch conversations: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get messages for a conversation
  /// GET /api/chat/conversation/{conversationId}
  static Future<Map<String, dynamic>> getConversationMessages(int conversationId) async {
    try {
      return await ApiService.get('/chat/conversation/$conversationId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch conversation messages: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get conversation by ID (alias for getConversationMessages)
  static Future<Map<String, dynamic>> getConversationById(int conversationId) async {
    return getConversationMessages(conversationId);
  }
}
