import '../api_service.dart';

/// Admin Service
/// Handles all admin related API calls
class AdminService {
  // ==================== DASHBOARD ====================

  /// Get admin dashboard data
  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await ApiService.get('/admin/dashboard');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch dashboard data: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get admin home data
  static Future<Map<String, dynamic>> getAdminHome() async {
    try {
      final response = await ApiService.get('/admin/home');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch admin home data: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get admin profile
  static Future<Map<String, dynamic>> getAdminProfile() async {
    try {
      final response = await ApiService.get('/admin/me');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch admin profile: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== USER MANAGEMENT ====================

  /// Get all users
  static Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final response = await ApiService.get('/admin/users');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch users: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get users by role
  static Future<Map<String, dynamic>> getUsersByRole(String role) async {
    try {
      final response = await ApiService.get('/admin/users/$role');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch users by role: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get user overview
  static Future<Map<String, dynamic>> getUserOverview() async {
    try {
      final response = await ApiService.get('/admin/user-overview');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch user overview: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get filtered user overview (users with at least 1 gig/order)
  static Future<Map<String, dynamic>> getFilteredUserOverview() async {
    try {
      final response = await ApiService.get('/admin/user-overview/filtered');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch filtered user overview: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update user status
  static Future<Map<String, dynamic>> updateUserStatus({
    required int userId,
    required String status, // 'active' or 'inactive'
  }) async {
    try {
      final response = await ApiService.put(
        '/admin/user/status',
        body: {
          'user_id': userId,
          'status': status,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update user status: $e',
        'statusCode': 500,
      };
    }
  }

  /// Deactivate user
  static Future<Map<String, dynamic>> deactivateUser(int userId) async {
    try {
      final response = await ApiService.put('/admin/user/$userId/deactivate');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to deactivate user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Reactivate user
  static Future<Map<String, dynamic>> reactivateUser(int userId) async {
    try {
      final response = await ApiService.put('/admin/user/$userId/reactivate');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to reactivate user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Change user role
  static Future<Map<String, dynamic>> changeUserRole({
    required int userId,
    required String role,
  }) async {
    try {
      final response = await ApiService.put(
        '/admin/user/$userId/change-role',
        body: {'role': role},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to change user role: $e',
        'statusCode': 500,
      };
    }
  }

  /// Soft delete user
  static Future<Map<String, dynamic>> softDeleteUser({
    required String email,
  }) async {
    try {
      final response = await ApiService.post(
        '/admin/user/delete',
        body: {'email': email},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Restore deleted user
  static Future<Map<String, dynamic>> restoreUser({
    required String email,
  }) async {
    try {
      final response = await ApiService.post(
        '/admin/restore-user',
        body: {'email': email},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to restore user: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== DISPUTE MANAGEMENT ====================

  /// Get all disputes
  static Future<Map<String, dynamic>> getAllDisputes() async {
    try {
      final response = await ApiService.get('/admin/disputes');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch disputes: $e',
        'statusCode': 500,
      };
    }
  }

  /// Resolve dispute
  static Future<Map<String, dynamic>> resolveDispute({
    required int disputeId,
    required String resolutionComment,
    String? status,
  }) async {
    try {
      final body = {
        'dispute_id': disputeId,
        'resolution_comment': resolutionComment,
      };
      
      if (status != null) {
        body['status'] = status;
      }

      final response = await ApiService.post(
        '/admin/resolve-dispute',
        body: body,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to resolve dispute: $e',
        'statusCode': 500,
      };
    }
  }

  /// Resolve dispute by ID
  static Future<Map<String, dynamic>> resolveDisputeById({
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

      final response = await ApiService.post(
        '/disputes/$disputeId/resolve',
        body: body,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to resolve dispute: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== ANALYTICS & REPORTS ====================

  /// Get creator analytics
  static Future<Map<String, dynamic>> getCreatorAnalytics() async {
    try {
      final response = await ApiService.get('/creator-home');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator analytics: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get platform statistics
  static Future<Map<String, dynamic>> getPlatformStatistics() async {
    try {
      final response = await ApiService.get('/admin/statistics');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch platform statistics: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get revenue reports
  static Future<Map<String, dynamic>> getRevenueReports({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await ApiService.get(
        '/admin/revenue-reports',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch revenue reports: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get user activity reports
  static Future<Map<String, dynamic>> getUserActivityReports({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await ApiService.get(
        '/admin/user-activity-reports',
        queryParams: queryParams,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch user activity reports: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== CONTENT MODERATION ====================

  /// Get reported content
  static Future<Map<String, dynamic>> getReportedContent() async {
    try {
      final response = await ApiService.get('/admin/reported-content');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch reported content: $e',
        'statusCode': 500,
      };
    }
  }

  /// Moderate content
  static Future<Map<String, dynamic>> moderateContent({
    required int contentId,
    required String action, // 'approve', 'reject', 'flag'
    String? reason,
  }) async {
    try {
      final body = {
        'content_id': contentId,
        'action': action,
      };
      
      if (reason != null) {
        body['reason'] = reason;
      }

      final response = await ApiService.post(
        '/admin/moderate-content',
        body: body,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to moderate content: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SYSTEM SETTINGS ====================

  /// Get system settings
  static Future<Map<String, dynamic>> getSystemSettings() async {
    try {
      final response = await ApiService.get('/admin/system-settings');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch system settings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update system settings
  static Future<Map<String, dynamic>> updateSystemSettings({
    required Map<String, dynamic> settings,
  }) async {
    try {
      final response = await ApiService.put(
        '/admin/system-settings',
        body: settings,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update system settings: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get platform notifications
  static Future<Map<String, dynamic>> getPlatformNotifications() async {
    try {
      final response = await ApiService.get('/admin/notifications');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch platform notifications: $e',
        'statusCode': 500,
      };
    }
  }

  /// Send platform notification
  static Future<Map<String, dynamic>> sendPlatformNotification({
    required String title,
    required String message,
    String? targetAudience, // 'all', 'buyers', 'creators'
    List<int>? userIds,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'message': message,
      };
      
      if (targetAudience != null) {
        body['target_audience'] = targetAudience;
      }
      
      if (userIds != null) {
        body['user_ids'] = userIds;
      }

      final response = await ApiService.post(
        '/admin/send-notification',
        body: body,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send platform notification: $e',
        'statusCode': 500,
      };
    }
  }
}
