import '../api_service.dart';

/// Payment Service
/// Handles all payment and subscription related API calls
class PaymentService {
  // ==================== PAYMENT INTENTS ====================

  /// Create payment intent
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

      final response = await ApiService.post('/create-payment-intent', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create payment intent: $e',
        'statusCode': 500,
      };
    }
  }

  /// Confirm payment
  static Future<Map<String, dynamic>> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await ApiService.post(
        '/confirm-payment',
        body: {
          'payment_intent_id': paymentIntentId,
          'payment_method_id': paymentMethodId,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to confirm payment: $e',
        'statusCode': 500,
      };
    }
  }

  /// Cancel payment
  static Future<Map<String, dynamic>> cancelPayment(String paymentIntentId) async {
    try {
      final response = await ApiService.post(
        '/cancel-payment',
        body: {'payment_intent_id': paymentIntentId},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to cancel payment: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get payment status
  static Future<Map<String, dynamic>> getPaymentStatus(String paymentIntentId) async {
    try {
      final response = await ApiService.get('/payment-status/$paymentIntentId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get payment status: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== STRIPE WEBHOOKS ====================

  /// Process Stripe webhook
  static Future<Map<String, dynamic>> processStripeWebhook({
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
        'error': 'Failed to process webhook: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SUBSCRIPTIONS ====================

  /// Create subscription
  static Future<Map<String, dynamic>> createSubscription({
    required String plan,
    required String paymentMethodId,
    String? couponCode,
  }) async {
    try {
      final body = {
        'plan': plan,
        'payment_method_id': paymentMethodId,
      };
      
      if (couponCode != null) {
        body['coupon_code'] = couponCode;
      }

      final response = await ApiService.post('/subscriptions', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create subscription: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get subscription details
  static Future<Map<String, dynamic>> getSubscription() async {
    try {
      final response = await ApiService.get('/subscription');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch subscription: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update subscription
  static Future<Map<String, dynamic>> updateSubscription({
    required String plan,
    String? paymentMethodId,
  }) async {
    try {
      final body = {'plan': plan};
      
      if (paymentMethodId != null) {
        body['payment_method_id'] = paymentMethodId;
      }

      final response = await ApiService.put('/subscription', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update subscription: $e',
        'statusCode': 500,
      };
    }
  }

  /// Cancel subscription
  static Future<Map<String, dynamic>> cancelSubscription({
    String? reason,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (reason != null) {
        body['reason'] = reason;
      }

      final response = await ApiService.post('/subscription/cancel', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to cancel subscription: $e',
        'statusCode': 500,
      };
    }
  }

  /// Resume subscription
  static Future<Map<String, dynamic>> resumeSubscription() async {
    try {
      final response = await ApiService.post('/subscription/resume');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to resume subscription: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get subscription history
  static Future<Map<String, dynamic>> getSubscriptionHistory() async {
    try {
      final response = await ApiService.get('/subscription/history');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch subscription history: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== PAYMENT METHODS ====================

  /// Get payment methods
  static Future<Map<String, dynamic>> getPaymentMethods() async {
    try {
      final response = await ApiService.get('/payment-methods');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch payment methods: $e',
        'statusCode': 500,
      };
    }
  }

  /// Add payment method
  static Future<Map<String, dynamic>> addPaymentMethod({
    required String paymentMethodId,
    bool setAsDefault = false,
  }) async {
    try {
      final response = await ApiService.post(
        '/payment-methods',
        body: {
          'payment_method_id': paymentMethodId,
          'set_as_default': setAsDefault,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add payment method: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update payment method
  static Future<Map<String, dynamic>> updatePaymentMethod({
    required String paymentMethodId,
    bool setAsDefault = false,
  }) async {
    try {
      final response = await ApiService.put(
        '/payment-methods/$paymentMethodId',
        body: {'set_as_default': setAsDefault},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update payment method: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete payment method
  static Future<Map<String, dynamic>> deletePaymentMethod(String paymentMethodId) async {
    try {
      final response = await ApiService.delete('/payment-methods/$paymentMethodId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete payment method: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== INVOICES ====================

  /// Get invoices
  static Future<Map<String, dynamic>> getInvoices({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiService.get(
        '/invoices',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch invoices: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get invoice by ID
  static Future<Map<String, dynamic>> getInvoiceById(String invoiceId) async {
    try {
      final response = await ApiService.get('/invoices/$invoiceId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch invoice: $e',
        'statusCode': 500,
      };
    }
  }

  /// Download invoice
  static Future<Map<String, dynamic>> downloadInvoice(String invoiceId) async {
    try {
      final response = await ApiService.get('/invoices/$invoiceId/download');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to download invoice: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== REFUNDS ====================

  /// Create refund
  static Future<Map<String, dynamic>> createRefund({
    required String paymentIntentId,
    required double amount,
    String? reason,
  }) async {
    try {
      final body = {
        'payment_intent_id': paymentIntentId,
        'amount': amount,
      };
      
      if (reason != null) {
        body['reason'] = reason;
      }

      final response = await ApiService.post('/refunds', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create refund: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get refunds
  static Future<Map<String, dynamic>> getRefunds({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiService.get(
        '/refunds',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch refunds: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get refund by ID
  static Future<Map<String, dynamic>> getRefundById(String refundId) async {
    try {
      final response = await ApiService.get('/refunds/$refundId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch refund: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== COUPONS ====================

  /// Validate coupon
  static Future<Map<String, dynamic>> validateCoupon({
    required String couponCode,
  }) async {
    try {
      final response = await ApiService.post(
        '/coupons/validate',
        body: {'coupon_code': couponCode},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to validate coupon: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get available coupons
  static Future<Map<String, dynamic>> getAvailableCoupons() async {
    try {
      final response = await ApiService.get('/coupons');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch coupons: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== EARNINGS ====================

  /// Get earnings
  static Future<Map<String, dynamic>> getEarnings({
    String? startDate,
    String? endDate,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiService.get(
        '/earnings',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch earnings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get earnings summary
  static Future<Map<String, dynamic>> getEarningsSummary({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await ApiService.get(
        '/earnings/summary',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch earnings summary: $e',
        'statusCode': 500,
      };
    }
  }

  /// Request payout
  static Future<Map<String, dynamic>> requestPayout({
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      final response = await ApiService.post(
        '/payouts/request',
        body: {
          'amount': amount,
          'payment_method': paymentMethod,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to request payout: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get payout history
  static Future<Map<String, dynamic>> getPayoutHistory({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await ApiService.get(
        '/payouts',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch payout history: $e',
        'statusCode': 500,
      };
    }
  }
}
