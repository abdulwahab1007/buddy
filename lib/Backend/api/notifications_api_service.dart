import '../api_service.dart';

/// Comprehensive Notifications API Service
/// Handles all notification-related API calls from the Postman collection
class NotificationsApiService {
  
  /// Get notifications
  /// GET /api/notifications
  static Future<Map<String, dynamic>> getNotifications({
    int? receiverId,
  }) async {
    try {
      Map<String, dynamic>? queryParams;
      if (receiverId != null) {
        queryParams = {'receiver_id': receiverId.toString()};
      }
      
      return await ApiService.get('/notifications', queryParams: queryParams);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch notifications: $e',
        'statusCode': 500,
      };
    }
  }

  /// Mark notification as read
  /// PUT /api/notifications/{id}/read
  static Future<Map<String, dynamic>> markNotificationAsRead(int notificationId) async {
    try {
      return await ApiService.put('/notifications/$notificationId/read');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to mark notification as read: $e',
        'statusCode': 500,
      };
    }
  }

  /// Mark all notifications as read
  /// PUT /api/notifications/read-all
  static Future<Map<String, dynamic>> markAllNotificationsAsRead() async {
    try {
      return await ApiService.put('/notifications/read-all');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to mark all notifications as read: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete notification
  /// DELETE /api/notifications/{id}
  static Future<Map<String, dynamic>> deleteNotification(int notificationId) async {
    try {
      return await ApiService.delete('/notifications/$notificationId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete notification: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get notification settings
  /// GET /api/notifications/settings
  static Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      return await ApiService.get('/notifications/settings');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch notification settings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update notification settings
  /// PUT /api/notifications/settings
  static Future<Map<String, dynamic>> updateNotificationSettings({
    required Map<String, dynamic> settings,
  }) async {
    try {
      return await ApiService.put('/notifications/settings', body: settings);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update notification settings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get unread notification count
  /// GET /api/notifications/unread-count
  static Future<Map<String, dynamic>> getUnreadNotificationCount() async {
    try {
      return await ApiService.get('/notifications/unread-count');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get unread notification count: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get conversations (alias for ChatApiService.getAllConversations)
  static Future<Map<String, dynamic>> getConversations() async {
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
}
