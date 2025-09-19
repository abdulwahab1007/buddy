import '../api_service.dart';

/// Comprehensive Payment API Service
/// Handles all payment-related API calls from the Postman collection
class PaymentApiService {
  
  /// Create payment intent
  /// POST /api/create-payment-intent
  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String plan,
    required String currency,
    int? gigId,
  }) async {
    try {
      final body = {
        'amount': amount,
        'plan': plan,
        'currency': currency,
      };
      
      if (gigId != null) {
        body['gig_id'] = gigId;
      }
      
      return await ApiService.post('/create-payment-intent', body: body);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create payment intent: $e',
        'statusCode': 500,
      };
    }
  }

  /// Process Stripe webhook
  /// POST /stripe/webhook
  static Future<Map<String, dynamic>> processStripeWebhook({
    required Map<String, dynamic> webhookData,
  }) async {
    try {
      return await ApiService.post('/stripe/webhook', body: webhookData);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to process webhook: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get payment history
  /// GET /api/payments/history
  static Future<Map<String, dynamic>> getPaymentHistory() async {
    try {
      return await ApiService.get('/payments/history');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch payment history: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get payment by ID
  /// GET /api/payments/{id}
  static Future<Map<String, dynamic>> getPaymentById(String paymentId) async {
    try {
      return await ApiService.get('/payments/$paymentId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch payment: $e',
        'statusCode': 500,
      };
    }
  }

  /// Refund payment
  /// POST /api/payments/{id}/refund
  static Future<Map<String, dynamic>> refundPayment({
    required String paymentId,
    double? amount,
    String? reason,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (amount != null) body['amount'] = amount;
      if (reason != null) body['reason'] = reason;
      
      return await ApiService.post('/payments/$paymentId/refund', body: body);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to refund payment: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get subscription status
  /// GET /api/subscription/status
  static Future<Map<String, dynamic>> getSubscriptionStatus() async {
    try {
      return await ApiService.get('/subscription/status');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch subscription status: $e',
        'statusCode': 500,
      };
    }
  }

  /// Cancel subscription
  /// POST /api/subscription/cancel
  static Future<Map<String, dynamic>> cancelSubscription() async {
    try {
      return await ApiService.post('/subscription/cancel');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to cancel subscription: $e',
        'statusCode': 500,
      };
    }
  }

  /// Upgrade subscription
  /// POST /api/subscription/upgrade
  static Future<Map<String, dynamic>> upgradeSubscription({
    required String newPlan,
  }) async {
    try {
      return await ApiService.post('/subscription/upgrade', body: {
        'new_plan': newPlan,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to upgrade subscription: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get available plans
  /// GET /api/subscription/plans
  static Future<Map<String, dynamic>> getAvailablePlans() async {
    try {
      return await ApiService.get('/subscription/plans');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch available plans: $e',
        'statusCode': 500,
      };
    }
  }
}
