import '../api_service.dart';

/// Buyer Service
/// Handles all buyer related API calls
class BuyerService {
  // ==================== GIGS & CONTENT ====================

  /// Get gig details
  static Future<Map<String, dynamic>> getGigDetails(int gigId) async {
    try {
      final response = await ApiService.get('/gigs/$gigId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch gig details: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get buyer content (stories and gigs)
  static Future<Map<String, dynamic>> getBuyerContent() async {
    try {
      final response = await ApiService.get('/buyer/content');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch content: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== ORDERS MANAGEMENT ====================

  /// Create order
  static Future<Map<String, dynamic>> createOrder({
    required int gigId,
    required String buyerName,
    required String email,
    required String projectDetails,
    required double budget,
    required String expectedDeliveryDate,
  }) async {
    try {
      final response = await ApiService.post(
        '/orders',
        body: {
          'gig_id': gigId,
          'buyer_name': buyerName,
          'email': email,
          'project_details': projectDetails,
          'budget': budget,
          'expected_delivery_date': expectedDeliveryDate,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create order: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get order details
  static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    try {
      final response = await ApiService.get('/order/$orderId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch order details: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get all buyer orders
  static Future<Map<String, dynamic>> getAllOrders() async {
    try {
      final response = await ApiService.get('/buyer/all/orders');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch orders: $e',
        'statusCode': 500,
      };
    }
  }

  /// Send reply to creator
  static Future<Map<String, dynamic>> sendReplyToCreator({
    required int orderId,
    required String message,
  }) async {
    try {
      final response = await ApiService.post(
        '/orders/$orderId/send-reply',
        body: {'message': message},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send reply: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== DISPUTES ====================

  /// Create dispute
  static Future<Map<String, dynamic>> createDispute({
    required int orderId,
    required String message,
    required String disputeType,
  }) async {
    try {
      final response = await ApiService.post(
        '/orders/$orderId/disputes',
        body: {
          'message': message,
          'dispute_type': disputeType,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create dispute: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get disputes
  static Future<Map<String, dynamic>> getDisputes() async {
    try {
      final response = await ApiService.get('/disputes');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch disputes: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== PROFILE MANAGEMENT ====================

  /// Create buyer profile
  static Future<Map<String, dynamic>> createProfile({
    required String contactNumber,
    required String about,
  }) async {
    try {
      final response = await ApiService.post(
        '/buyer-profile',
        body: {
          'contact_number': contactNumber,
          'about': about,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get buyer profile
  static Future<Map<String, dynamic>> getProfile(int buyerId) async {
    try {
      final response = await ApiService.get('/buyer-profile/$buyerId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update buyer profile
  static Future<Map<String, dynamic>> updateProfile({
    required int buyerId,
    String? name,
    String? contactNumber,
    String? about,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (contactNumber != null) body['contact_number'] = contactNumber;
      if (about != null) body['about'] = about;

      final response = await ApiService.put('/buyer-profile/$buyerId', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete buyer profile
  static Future<Map<String, dynamic>> deleteProfile(int buyerId) async {
    try {
      final response = await ApiService.delete('/buyer-profile/$buyerId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete profile: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SEARCH ====================

  /// Search services
  static Future<Map<String, dynamic>> searchServices({
    required String keyword,
  }) async {
    try {
      final response = await ApiService.post(
        '/services/search',
        body: {'keyword': keyword},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to search services: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get service recommendations
  static Future<Map<String, dynamic>> getServiceRecommendations() async {
    try {
      final response = await ApiService.get('/services/recommendations');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch recommendations: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== CHAT ====================

  /// Send chat message
  static Future<Map<String, dynamic>> sendChatMessage({
    required int gigId,
    required int senderId,
    required int receiverId,
    required String chat,
  }) async {
    try {
      final response = await ApiService.post(
        '/realtime-chat/send',
        body: {
          'gig_id': gigId,
          'sender_id': senderId,
          'receiver_id': receiverId,
          'chat': chat,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send chat message: $e',
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

  /// Get all conversations
  static Future<Map<String, dynamic>> getAllConversations() async {
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

  /// Send message in conversation
  static Future<Map<String, dynamic>> sendMessageInConversation({
    required int conversationId,
    required String message,
  }) async {
    try {
      final response = await ApiService.post(
        '/realtime-chat/send',
        body: {
          'conversation_id': conversationId,
          'message': message,
        },
      );
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
  static Future<Map<String, dynamic>> getUnreadCount() async {
    try {
      final response = await ApiService.get('/chat/unread-count');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch unread count: $e',
        'statusCode': 500,
      };
    }
  }

  /// Archive chat
  static Future<Map<String, dynamic>> archiveChat(int conversationId) async {
    try {
      final response = await ApiService.put('/chat/archive/$conversationId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to archive chat: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete chat
  static Future<Map<String, dynamic>> deleteChat(int conversationId) async {
    try {
      final response = await ApiService.delete('/chat/delete/$conversationId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete chat: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== PAYMENT ====================

  /// Create payment intent
  static Future<Map<String, dynamic>> createPaymentIntent({
    required int gigId,
    required double amount,
    required String plan,
    required String currency,
  }) async {
    try {
      final response = await ApiService.post(
        '/create-payment-intent',
        body: {
          'gig_id': gigId,
          'amount': amount,
          'plan': plan,
          'currency': currency,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create payment intent: $e',
        'statusCode': 500,
      };
    }
  }

  /// Process payment webhook
  static Future<Map<String, dynamic>> processPaymentWebhook({
    required String type,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await ApiService.post(
        '/stripe/webhook',
        body: {
          'type': type,
          'data': data,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to process payment webhook: $e',
        'statusCode': 500,
      };
    }
  }
}
