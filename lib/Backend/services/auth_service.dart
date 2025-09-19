import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';

/// Authentication Service
/// Handles all authentication-related API calls
class AuthService {
  /// Register a new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role, // 'Buyer' or 'Content Creator'
  }) async {
    try {
      final response = await ApiService.post(
        '/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'role': role,
        },
      );

      if (response['success']) {
        // Store auth token if provided
        final data = response['data'];
        if (data != null && data['token'] != null) {
          await _storeAuthData(data);
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Registration failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        '/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response['success']) {
        // Store auth data
        final data = response['data'];
        if (data != null) {
          await _storeAuthData(data);
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Login failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Logout user
  static Future<void> logout() async {
    try {
      // Call logout endpoint if available
      await ApiService.post('/logout');
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear local storage
      await _clearAuthData();
    }
  }

  /// Get current user profile
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await ApiService.get('/user');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get user profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Social login (Google/Facebook)
  static Future<Map<String, dynamic>> socialLogin({
    required String provider, // 'google' or 'facebook'
    required String token,
  }) async {
    try {
      final response = await ApiService.post(
        '/social-login',
        body: {
          'provider': provider,
          'token': token,
        },
      );

      if (response['success']) {
        final data = response['data'];
        if (data != null) {
          await _storeAuthData(data);
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Social login failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Refresh authentication token
  static Future<Map<String, dynamic>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await ApiService.post(
        '/refresh-token',
        body: {
          'refresh_token': refreshToken,
        },
      );

      if (response['success']) {
        final data = response['data'];
        if (data != null) {
          await _storeAuthData(data);
        }
      }

      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Token refresh failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get stored auth token
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  /// Get stored user ID
  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('user_id');
    } catch (e) {
      return null;
    }
  }

  /// Get stored user role
  static Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_role');
    } catch (e) {
      return null;
    }
  }

  /// Store authentication data locally
  static Future<void> _storeAuthData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (data['token'] != null) {
        await prefs.setString('auth_token', data['token']);
      }
      
      if (data['user'] != null) {
        final user = data['user'];
        if (user['id'] != null) {
          await prefs.setInt('user_id', user['id']);
        }
        if (user['role'] != null) {
          await prefs.setString('user_role', user['role']);
        }
        if (user['name'] != null) {
          await prefs.setString('user_name', user['name']);
        }
        if (user['email'] != null) {
          await prefs.setString('user_email', user['email']);
        }
      }
      
      if (data['refresh_token'] != null) {
        await prefs.setString('refresh_token', data['refresh_token']);
      }
    } catch (e) {
      throw Exception('Failed to store auth data: $e');
    }
  }

  /// Clear authentication data from local storage
  static Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('user_role');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('refresh_token');
    } catch (e) {
      throw Exception('Failed to clear auth data: $e');
    }
  }

  /// Forgot password
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await ApiService.post(
        '/forgot-password',
        body: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Forgot password request failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Reset password
  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await ApiService.post(
        '/reset-password',
        body: {
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Password reset failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Verify email
  static Future<Map<String, dynamic>> verifyEmail({
    required String token,
  }) async {
    try {
      final response = await ApiService.post(
        '/verify-email',
        body: {
          'token': token,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Email verification failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Resend verification email
  static Future<Map<String, dynamic>> resendVerificationEmail() async {
    try {
      final response = await ApiService.post('/resend-verification');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to resend verification email: $e',
        'statusCode': 500,
      };
    }
  }
}
