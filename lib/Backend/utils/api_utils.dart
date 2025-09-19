import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../exceptions/api_exceptions.dart';

/// API Utility Functions
/// Helper functions for API operations

class ApiUtils {
  /// Check if response is successful
  static bool isSuccessResponse(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if response is client error
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if response is server error
  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  /// Get error message from response
  static String getErrorMessage(http.Response response) {
    try {
      final jsonData = jsonDecode(response.body);
      return jsonData['message'] ?? 
             jsonData['error'] ?? 
             'Request failed with status ${response.statusCode}';
    } catch (e) {
      return 'Request failed with status ${response.statusCode}';
    }
  }

  /// Get validation errors from response
  static Map<String, List<String>> getValidationErrors(http.Response response) {
    try {
      final jsonData = jsonDecode(response.body);
      final errors = jsonData['errors'] as Map<String, dynamic>?;
      
      if (errors != null) {
        return errors.map(
          (key, value) => MapEntry(
            key, 
            List<String>.from(value as List<dynamic>)
          ),
        );
      }
    } catch (e) {
      // Return empty map if parsing fails
    }
    
    return {};
  }

  /// Create exception from response
  static ApiException createExceptionFromResponse(http.Response response) {
    final statusCode = response.statusCode;
    final message = getErrorMessage(response);
    
    if (statusCode == 422) {
      final validationErrors = getValidationErrors(response);
      return ValidationException(message, validationErrors: validationErrors);
    }
    
    return ApiExceptionFactory.createException(statusCode, message);
  }

  /// Handle network errors
  static ApiException handleNetworkError(dynamic error) {
    if (error is SocketException) {
      return NetworkException('No internet connection');
    } else if (error is HttpException) {
      return NetworkException('HTTP error: ${error.message}');
    } else if (error is FormatException) {
      return NetworkException('Invalid response format');
    } else {
      return NetworkException('Network error: ${error.toString()}');
    }
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }

  /// Validate password strength
  static bool isStrongPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }

  /// Generate random string
  static String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      buffer.write(chars[(random + i) % chars.length]);
    }
    
    return buffer.toString();
  }

  /// Convert map to query string
  static String mapToQueryString(Map<String, dynamic> params) {
    final queryParams = <String>[];
    
    params.forEach((key, value) {
      if (value != null) {
        queryParams.add('$key=${Uri.encodeComponent(value.toString())}');
      }
    });
    
    return queryParams.join('&');
  }

  /// Convert query string to map
  static Map<String, String> queryStringToMap(String queryString) {
    final params = <String, String>{};
    
    if (queryString.isNotEmpty) {
      final pairs = queryString.split('&');
      
      for (final pair in pairs) {
        final keyValue = pair.split('=');
        if (keyValue.length == 2) {
          params[Uri.decodeComponent(keyValue[0])] = 
              Uri.decodeComponent(keyValue[1]);
        }
      }
    }
    
    return params;
  }

  /// Sanitize filename
  static String sanitizeFilename(String filename) {
    return filename.replaceAll(RegExp(r'[^\w\s-.]'), '').trim();
  }

  /// Get file extension
  static String getFileExtension(String filename) {
    final lastDot = filename.lastIndexOf('.');
    return lastDot != -1 ? filename.substring(lastDot + 1).toLowerCase() : '';
  }

  /// Check if file is image
  static bool isImageFile(String filename) {
    final extension = getFileExtension(filename);
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension);
  }

  /// Check if file is video
  static bool isVideoFile(String filename) {
    final extension = getFileExtension(filename);
    const videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
    return videoExtensions.contains(extension);
  }

  /// Check if file is document
  static bool isDocumentFile(String filename) {
    final extension = getFileExtension(filename);
    const documentExtensions = ['pdf', 'doc', 'docx', 'txt', 'rtf'];
    return documentExtensions.contains(extension);
  }

  /// Format currency
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format date
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return '${date.year.toString().padLeft(4, '0')}-'
           '${date.month.toString().padLeft(2, '0')}-'
           '${date.day.toString().padLeft(2, '0')}';
  }

  /// Format datetime
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}:'
           '${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// Parse date from string
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get time ago string
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Convert camelCase to snake_case
  static String camelToSnake(String text) {
    return text.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }

  /// Convert snake_case to camelCase
  static String snakeToCamel(String text) {
    return text.replaceAllMapped(
      RegExp(r'_([a-z])'),
      (match) => match.group(1)!.toUpperCase(),
    );
  }

  /// Deep merge maps
  static Map<String, dynamic> deepMerge(
    Map<String, dynamic> map1,
    Map<String, dynamic> map2,
  ) {
    final result = Map<String, dynamic>.from(map1);
    
    map2.forEach((key, value) {
      if (result.containsKey(key) && 
          result[key] is Map<String, dynamic> && 
          value is Map<String, dynamic>) {
        result[key] = deepMerge(
          result[key] as Map<String, dynamic>,
          value,
        );
      } else {
        result[key] = value;
      }
    });
    
    return result;
  }

  /// Remove null values from map
  static Map<String, dynamic> removeNullValues(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    
    map.forEach((key, value) {
      if (value != null) {
        if (value is Map<String, dynamic>) {
          final cleaned = removeNullValues(value);
          if (cleaned.isNotEmpty) {
            result[key] = cleaned;
          }
        } else {
          result[key] = value;
        }
      }
    });
    
    return result;
  }
}
