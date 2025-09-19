import 'dart:io';
import '../api_service.dart';

/// Comprehensive Orders API Service
/// Handles all order-related API calls from the Postman collection
class OrdersApiService {
  
  /// Create a new order
  /// POST /api/orders
  static Future<Map<String, dynamic>> createOrder({
    required int gigId,
    required String buyerName,
    required String email,
    required String projectDetails,
    required double budget,
    required String expectedDeliveryDate,
  }) async {
    try {
      return await ApiService.post('/orders', body: {
        'gig_id': gigId,
        'buyer_name': buyerName,
        'email': email,
        'project_details': projectDetails,
        'budget': budget,
        'expected_delivery_date': expectedDeliveryDate,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create order: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get order by ID
  /// GET /api/order/{id}
  static Future<Map<String, dynamic>> getOrderById(int orderId) async {
    try {
      return await ApiService.get('/order/$orderId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch order: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get all buyer orders
  /// GET /api/buyer/all/orders
  static Future<Map<String, dynamic>> getBuyerAllOrders() async {
    try {
      return await ApiService.get('/buyer/all/orders');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch buyer orders: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator orders
  /// GET /api/creator/my-orders
  static Future<Map<String, dynamic>> getCreatorOrders() async {
    try {
      return await ApiService.get('/creator/my-orders');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator orders: $e',
        'statusCode': 500,
      };
    }
  }

  /// Respond to order (accept/reject)
  /// POST /api/orders/{id}/respond
  static Future<Map<String, dynamic>> respondToOrder({
    required int orderId,
    required String action, // 'accept' or 'reject'
  }) async {
    try {
      return await ApiService.post('/orders/$orderId/respond', body: {
        'action': action,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to respond to order: $e',
        'statusCode': 500,
      };
    }
  }

  /// Send message to buyer
  /// POST /api/orders/{id}/message
  static Future<Map<String, dynamic>> sendMessageToBuyer({
    required int orderId,
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    try {
      return await ApiService.post('/orders/$orderId/message', body: {
        'sender_id': senderId,
        'receiver_id': receiverId,
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

  /// Send reply to creator
  /// POST /api/orders/{id}/send-reply
  static Future<Map<String, dynamic>> sendReplyToCreator({
    required int orderId,
    required String message,
  }) async {
    try {
      return await ApiService.post('/orders/$orderId/send-reply', body: {
        'message': message,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send reply: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update order milestone
  /// PATCH /api/orders/{id}/milestone
  static Future<Map<String, dynamic>> updateOrderMilestone({
    required int orderId,
    required String milestone,
  }) async {
    try {
      return await ApiService.patch('/orders/$orderId/milestone', body: {
        'milestone': milestone,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update milestone: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update order progress status
  /// PATCH /api/orders/{id}/progress-status
  static Future<Map<String, dynamic>> updateOrderProgressStatus({
    required int orderId,
    required String progressStatus,
  }) async {
    try {
      return await ApiService.patch('/orders/$orderId/progress-status', body: {
        'progress_status': progressStatus,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update progress status: $e',
        'statusCode': 500,
      };
    }
  }

  /// Upload work for order
  /// POST /api/orders/{id}/upload-work
  static Future<Map<String, dynamic>> uploadWork({
    required int orderId,
    required File file,
    required String message,
  }) async {
    try {
      return await ApiService.postMultipart(
        '/orders/$orderId/upload-work',
        fields: {
          'message': message,
        },
        files: {
          'file': file,
        },
      );
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to upload work: $e',
        'statusCode': 500,
      };
    }
  }

  /// View uploaded work submissions
  /// GET /api/orders/{id}/view-submissions
  static Future<Map<String, dynamic>> viewOrderSubmissions(int orderId) async {
    try {
      return await ApiService.get('/orders/$orderId/view-submissions');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch submissions: $e',
        'statusCode': 500,
      };
    }
  }

  /// Create dispute
  /// POST /api/orders/{id}/disputes
  static Future<Map<String, dynamic>> createDispute({
    required int orderId,
    required String message,
    required String disputeType,
  }) async {
    try {
      return await ApiService.post('/orders/$orderId/disputes', body: {
        'message': message,
        'dispute_type': disputeType,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create dispute: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get all disputes
  /// GET /api/disputes
  static Future<Map<String, dynamic>> getAllDisputes() async {
    try {
      return await ApiService.get('/disputes');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch disputes: $e',
        'statusCode': 500,
      };
    }
  }

  /// Resolve dispute (Admin only)
  /// POST /api/disputes/{id}/resolve
  static Future<Map<String, dynamic>> resolveDispute({
    required int disputeId,
    required String resolutionComment,
    String? status,
  }) async {
    try {
      final body = {
        'resolution_comment': resolutionComment,
      };
      if (status != null) {
        body['status'] = status;
      }
      
      return await ApiService.post('/disputes/$disputeId/resolve', body: body);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to resolve dispute: $e',
        'statusCode': 500,
      };
    }
  }
}
