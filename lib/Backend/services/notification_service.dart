import '../api_service.dart';

/// Notification Service
/// Handles all notification related API calls
class NotificationService {
  // ==================== NOTIFICATIONS ====================

  /// Get notifications
  static Future<Map<String, dynamic>> getNotifications({
    int? receiverId,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (receiverId != null) queryParams['receiver_id'] = receiverId;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiService.get(
        '/notifications',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch notifications: $e',
        'statusCode': 500,
      };
    }
  }

  /// Mark notification as read
  static Future<Map<String, dynamic>> markNotificationAsRead(int notificationId) async {
    try {
      final response = await ApiService.put('/notifications/$notificationId/read');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to mark notification as read: $e',
        'statusCode': 500,
      };
    }
  }

  /// Mark all notifications as read
  static Future<Map<String, dynamic>> markAllNotificationsAsRead() async {
    try {
      final response = await ApiService.put('/notifications/read-all');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to mark all notifications as read: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete notification
  static Future<Map<String, dynamic>> deleteNotification(int notificationId) async {
    try {
      final response = await ApiService.delete('/notifications/$notificationId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete notification: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get unread notification count
  static Future<Map<String, dynamic>> getUnreadNotificationCount() async {
    try {
      final response = await ApiService.get('/notifications/unread-count');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch unread notification count: $e',
        'statusCode': 500,
      };
    }
  }

  /// Create notification
  static Future<Map<String, dynamic>> createNotification({
    required int receiverId,
    required String title,
    required String message,
    String? type,
    Map<String, dynamic>? data,
  }) async {
    try {
      final body = {
        'receiver_id': receiverId,
        'title': title,
        'message': message,
      };
      
      if (type != null) body['type'] = type;
      if (data != null) body['data'] = data;

      final response = await ApiService.post('/notifications', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create notification: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update notification settings
  static Future<Map<String, dynamic>> updateNotificationSettings({
    required Map<String, bool> settings,
  }) async {
    try {
      final response = await ApiService.put(
        '/notifications/settings',
        body: settings,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update notification settings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get notification settings
  static Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final response = await ApiService.get('/notifications/settings');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch notification settings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get conversations (alias for ChatService.getConversations)
  static Future<Map<String, dynamic>> getConversations() async {
    return ChatService.getConversations();
  }
}

/// Chat Service
/// Handles all chat related API calls
class ChatService {
  // ==================== CONVERSATIONS ====================

  /// Get all conversations
  static Future<Map<String, dynamic>> getConversations() async {
    try {
      final response = await ApiService.get('/chat/conversations');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch conversations: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get conversation messages
  static Future<Map<String, dynamic>> getConversationMessages(int conversationId) async {
    try {
      final response = await ApiService.get('/chat/conversation/$conversationId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch conversation messages: $e',
        'statusCode': 500,
      };
    }
  }

  /// Start conversation from gig
  static Future<Map<String, dynamic>> startConversationFromGig(int gigId) async {
    try {
      final response = await ApiService.post('/chat/start/$gigId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to start conversation: $e',
        'statusCode': 500,
      };
    }
  }

  /// Send message
  static Future<Map<String, dynamic>> sendMessage({
    int? conversationId,
    int? gigId,
    int? senderId,
    int? receiverId,
    required String message,
  }) async {
    try {
      final body = {'message': message};
      
      if (conversationId != null) {
        body['conversation_id'] = conversationId.toString();
      }
      
      if (gigId != null) {
        body['gig_id'] = gigId.toString();
      }
      
      if (senderId != null) {
        body['sender_id'] = senderId.toString();
      }
      
      if (receiverId != null) {
        body['receiver_id'] = receiverId.toString();
      }

      final response = await ApiService.post('/realtime-chat/send', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send message: $e',
        'statusCode': 500,
      };
    }
  }

  /// Mark message as read
  static Future<Map<String, dynamic>> markMessageAsRead(int messageId) async {
    try {
      final response = await ApiService.put('/chat/messages/read/$messageId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to mark message as read: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get unread message count
  static Future<Map<String, dynamic>> getUnreadMessageCount() async {
    try {
      final response = await ApiService.get('/chat/unread-count');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch unread message count: $e',
        'statusCode': 500,
      };
    }
  }

  /// Archive conversation
  static Future<Map<String, dynamic>> archiveConversation(int conversationId) async {
    try {
      final response = await ApiService.put('/chat/archive/$conversationId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to archive conversation: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete conversation
  static Future<Map<String, dynamic>> deleteConversation(int conversationId) async {
    try {
      final response = await ApiService.delete('/chat/delete/$conversationId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete conversation: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get conversation by ID
  static Future<Map<String, dynamic>> getConversationById(int conversationId) async {
    try {
      final response = await ApiService.get('/chat/conversation/$conversationId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch conversation: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update conversation settings
  static Future<Map<String, dynamic>> updateConversationSettings({
    required int conversationId,
    required Map<String, dynamic> settings,
  }) async {
    try {
      final response = await ApiService.put(
        '/chat/conversation/$conversationId/settings',
        body: settings,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update conversation settings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Block user in conversation
  static Future<Map<String, dynamic>> blockUser({
    required int conversationId,
    required int userId,
  }) async {
    try {
      final response = await ApiService.post(
        '/chat/conversation/$conversationId/block',
        body: {'user_id': userId},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to block user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Unblock user in conversation
  static Future<Map<String, dynamic>> unblockUser({
    required int conversationId,
    required int userId,
  }) async {
    try {
      final response = await ApiService.post(
        '/chat/conversation/$conversationId/unblock',
        body: {'user_id': userId},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to unblock user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Report conversation
  static Future<Map<String, dynamic>> reportConversation({
    required int conversationId,
    required String reason,
    String? description,
  }) async {
    try {
      final body = {
        'conversation_id': conversationId,
        'reason': reason,
      };
      
      if (description != null) {
        body['description'] = description;
      }

      final response = await ApiService.post('/chat/report', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to report conversation: $e',
        'statusCode': 500,
      };
    }
  }
}
