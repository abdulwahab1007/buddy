import '../api_service.dart';

/// Comprehensive Admin API Service
/// Handles all admin-related API calls from the Postman collection
class AdminApiService {
  
  /// Get admin dashboard
  /// GET /api/admin/home
  static Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      return await ApiService.get('/admin/home');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch admin dashboard: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get admin dashboard (alternative endpoint)
  /// GET /api/admin/dashboard
  static Future<Map<String, dynamic>> getAdminDashboardAlt() async {
    try {
      return await ApiService.get('/admin/dashboard');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch admin dashboard: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get all users
  /// GET /api/admin/users
  static Future<Map<String, dynamic>> getAllUsers() async {
    try {
      return await ApiService.get('/admin/users');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch all users: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get users by role
  /// GET /api/admin/users/{role}
  static Future<Map<String, dynamic>> getUsersByRole(String role) async {
    try {
      return await ApiService.get('/admin/users/$role');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch users by role: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get admin profile
  /// GET /api/admin/me
  static Future<Map<String, dynamic>> getAdminProfile() async {
    try {
      return await ApiService.get('/admin/me');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch admin profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update user status
  /// PUT /api/admin/user/status
  static Future<Map<String, dynamic>> updateUserStatus({
    required int userId,
    required String status,
  }) async {
    try {
      return await ApiService.put('/admin/user/status', body: {
        'user_id': userId,
        'status': status,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update user status: $e',
        'statusCode': 500,
      };
    }
  }

  /// Deactivate user
  /// PUT /api/admin/user/{id}/deactivate
  static Future<Map<String, dynamic>> deactivateUser(int userId) async {
    try {
      return await ApiService.put('/admin/user/$userId/deactivate');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to deactivate user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Reactivate user
  /// PUT /api/admin/user/{id}/reactivate
  static Future<Map<String, dynamic>> reactivateUser(int userId) async {
    try {
      return await ApiService.put('/admin/user/$userId/reactivate');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to reactivate user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Change user role
  /// PUT /api/admin/user/{id}/change-role
  static Future<Map<String, dynamic>> changeUserRole({
    required int userId,
    required String role,
  }) async {
    try {
      return await ApiService.put('/admin/user/$userId/change-role', body: {
        'role': role,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to change user role: $e',
        'statusCode': 500,
      };
    }
  }

  /// Soft delete user
  /// DELETE /api/admin/user/delete
  static Future<Map<String, dynamic>> softDeleteUser({
    required String email,
  }) async {
    try {
      // For DELETE requests, we need to send the email as a query parameter
      return await ApiService.delete('/admin/user/delete', queryParams: {
        'email': email,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to soft delete user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Restore user
  /// POST /api/admin/restore-user
  static Future<Map<String, dynamic>> restoreUser({
    required String email,
  }) async {
    try {
      return await ApiService.post('/admin/restore-user', body: {
        'email': email,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to restore user: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get user overview
  /// GET /api/admin/user-overview
  static Future<Map<String, dynamic>> getUserOverview() async {
    try {
      return await ApiService.get('/admin/user-overview');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch user overview: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get filtered user overview
  /// GET /api/admin/user-overview/filtered
  static Future<Map<String, dynamic>> getFilteredUserOverview() async {
    try {
      return await ApiService.get('/admin/user-overview/filtered');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch filtered user overview: $e',
        'statusCode': 500,
      };
    }
  }

  /// Resolve dispute
  /// POST /api/admin/resolve-dispute
  static Future<Map<String, dynamic>> resolveDispute({
    required int disputeId,
    required String resolutionComment,
  }) async {
    try {
      return await ApiService.post('/admin/resolve-dispute', body: {
        'dispute_id': disputeId,
        'resolution_comment': resolutionComment,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to resolve dispute: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator home data (admin view)
  /// GET /api/creator-home
  static Future<Map<String, dynamic>> getCreatorHomeAdmin() async {
    try {
      return await ApiService.get('/creator-home');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator home data: $e',
        'statusCode': 500,
      };
    }
  }
}
