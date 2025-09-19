import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';

/// Comprehensive Authentication API Service
/// Handles all authentication-related API calls from the Postman collection
class AuthApiService {
  // ignore: unused_field
  static const String _baseUrl = "https://buddy.nexltech.com/public/api";
  
  /// Register a new user
  /// POST /api/register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await ApiService.post('/register', body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'role': role,
      });
      
      if (response['success']) {
        // Save user data if needed
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        await prefs.setString('user_role', role);
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
  /// POST /api/login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/login', body: {
        'email': email,
        'password': password,
      });
      
      if (response['success']) {
        final data = response['data'];
        final token = data['token'] ?? data['data']?['token'];
        final userRole = _extractRole(data);
        final userId = _extractUserId(data);
        
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_role', userRole ?? 'buyer');
          if (userId != null) {
            await prefs.setInt('user_id', userId);
          }
          
          // Save token timestamp
          await prefs.setInt('token_saved_time', DateTime.now().millisecondsSinceEpoch);
          
          return {
            'success': true,
            'token': token,
            'role': userRole ?? 'buyer',
            'user_id': userId,
            'data': data,
          };
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

  /// Get current user information
  /// GET /api/user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      return await ApiService.get('/user');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get user info: $e',
        'statusCode': 500,
      };
    }
  }

  /// Social login redirect
  /// GET /api/social-login
  static Future<Map<String, dynamic>> socialLogin() async {
    try {
      return await ApiService.get('/social-login');
    } catch (e) {
      return {
        'success': false,
        'error': 'Social login failed: $e',
        'statusCode': 500,
      };
    }
  }

  /// Logout user
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_role');
      await prefs.remove('user_id');
      await prefs.remove('token_saved_time');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
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

  /// Get stored user role
  static Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_role');
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

  /// Helper method to extract role from response data
  static String? _extractRole(Map<String, dynamic> data) {
    final roleData = data['role'] ?? data['data']?['role'];
    if (roleData != null) {
      if (roleData is List) {
        return roleData.isNotEmpty ? roleData[0].toString() : 'buyer';
      } else {
        return roleData.toString();
      }
    }
    return 'buyer';
  }

  /// Helper method to extract user ID from response data
  static int? _extractUserId(Map<String, dynamic> data) {
    final userId = data['id'] ?? 
                   data['user_id'] ?? 
                   data['data']?['id'] ?? 
                   data['data']?['user_id'];
    return userId != null ? int.tryParse(userId.toString()) : null;
  }
}
