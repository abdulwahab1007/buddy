import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../helpers/auth_helper.dart';

/// Main API Service class that handles all HTTP requests
/// Follows professional standards with proper error handling and response management
class ApiService {
  static const String _baseUrl = "https://buddy.nexltech.com/public/api";
  
  // Use production URL by default, can be switched for development
  static String get baseUrl => _baseUrl;
  
  /// Generic HTTP GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.get(
        uri,
        headers: await _getHeaders(headers),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e');
    }
  }

  /// Generic HTTP POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.post(
        uri,
        headers: await _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('POST request failed: $e');
    }
  }

  /// Generic HTTP PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.put(
        uri,
        headers: await _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('PUT request failed: $e');
    }
  }

  /// Generic HTTP DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.delete(
        uri,
        headers: await _getHeaders(headers),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('DELETE request failed: $e');
    }
  }

  /// Generic HTTP PATCH request
  static Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http.patch(
        uri,
        headers: await _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('PATCH request failed: $e');
    }
  }

  /// Multipart POST request for file uploads
  static Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, File> files,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      final authHeaders = await _getHeaders(headers);
      request.headers.addAll(authHeaders);
      
      // Add fields
      request.fields.addAll(fields);
      
      // Add files
      for (final entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
        );
      }
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Multipart POST request failed: $e');
    }
  }

  /// Build URI with query parameters
  static Uri _buildUri(String endpoint, Map<String, dynamic>? queryParams) {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParams.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    
    return uri;
  }

  /// Get headers with authentication
  static Future<Map<String, String>> _getHeaders(Map<String, String>? customHeaders) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    
    // Add authentication token if available
    try {
      final token = await getAuthToken();
      headers['Authorization'] = 'Bearer $token';
    } catch (e) {
      // Token not available, continue without auth
    }
    
    // Add custom headers
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    
    return headers;
  }

  /// Handle HTTP response and convert to standard format
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;
    
    try {
      final jsonData = jsonDecode(body);
      
      if (statusCode >= 200 && statusCode < 300) {
        return {
          'success': true,
          'data': jsonData,
          'statusCode': statusCode,
        };
      } else {
        return {
          'success': false,
          'error': jsonData['message'] ?? 'Request failed',
          'statusCode': statusCode,
          'data': jsonData,
        };
      }
    } catch (e) {
      if (statusCode >= 200 && statusCode < 300) {
        return {
          'success': true,
          'data': body,
          'statusCode': statusCode,
        };
      } else {
        return {
          'success': false,
          'error': 'Invalid response format',
          'statusCode': statusCode,
          'data': body,
        };
      }
    }
  }
}

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message';
}

/// Response wrapper class for consistent API responses
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'],
      error: json['error'],
      statusCode: json['statusCode'] ?? 0,
    );
  }
}