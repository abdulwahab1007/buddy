/// API Response Models
/// Standardized response models for consistent API communication

/// Base API Response Model
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    required this.statusCode,
    this.message,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      error: json['error'],
      statusCode: json['statusCode'] ?? 0,
      message: json['message'],
      meta: json['meta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'error': error,
      'statusCode': statusCode,
      'message': message,
      'meta': meta,
    };
  }
}

/// Paginated API Response Model
class PaginatedResponse<T> {
  final bool success;
  final List<T> data;
  final String? error;
  final int statusCode;
  final String? message;
  final PaginationMeta? pagination;

  PaginatedResponse({
    required this.success,
    required this.data,
    this.error,
    required this.statusCode,
    this.message,
    this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => fromJsonT(item))
          .toList() ?? [],
      error: json['error'],
      statusCode: json['statusCode'] ?? 0,
      message: json['message'],
      pagination: json['pagination'] != null
          ? PaginationMeta.fromJson(json['pagination'])
          : null,
    );
  }
}

/// Pagination Meta Information
class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
    };
  }
}

/// Error Response Model
class ErrorResponse {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;
  final int statusCode;

  ErrorResponse({
    required this.message,
    this.code,
    this.details,
    required this.statusCode,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? 'An error occurred',
      code: json['code'],
      details: json['details'],
      statusCode: json['statusCode'] ?? 500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'details': details,
      'statusCode': statusCode,
    };
  }
}

/// Validation Error Response Model
class ValidationErrorResponse {
  final String message;
  final Map<String, List<String>> errors;
  final int statusCode;

  ValidationErrorResponse({
    required this.message,
    required this.errors,
    required this.statusCode,
  });

  factory ValidationErrorResponse.fromJson(Map<String, dynamic> json) {
    return ValidationErrorResponse(
      message: json['message'] ?? 'Validation failed',
      errors: Map<String, List<String>>.from(
        json['errors']?.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ) ?? {},
      ),
      statusCode: json['statusCode'] ?? 422,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errors': errors,
      'statusCode': statusCode,
    };
  }
}

/// Success Response Model
class SuccessResponse<T> {
  final bool success;
  final T data;
  final String? message;
  final int statusCode;

  SuccessResponse({
    required this.success,
    required this.data,
    this.message,
    required this.statusCode,
  });

  factory SuccessResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return SuccessResponse<T>(
      success: json['success'] ?? true,
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      message: json['message'],
      statusCode: json['statusCode'] ?? 200,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'statusCode': statusCode,
    };
  }
}

/// File Upload Response Model
class FileUploadResponse {
  final bool success;
  final String? fileUrl;
  final String? fileName;
  final String? fileType;
  final int? fileSize;
  final String? error;
  final int statusCode;

  FileUploadResponse({
    required this.success,
    this.fileUrl,
    this.fileName,
    this.fileType,
    this.fileSize,
    this.error,
    required this.statusCode,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      success: json['success'] ?? false,
      fileUrl: json['file_url'],
      fileName: json['file_name'],
      fileType: json['file_type'],
      fileSize: json['file_size'],
      error: json['error'],
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_type': fileType,
      'file_size': fileSize,
      'error': error,
      'statusCode': statusCode,
    };
  }
}

/// Authentication Response Model
class AuthResponse {
  final bool success;
  final String? token;
  final String? refreshToken;
  final List<String>? roles;
  final UserData? user;
  final String? error;
  final int statusCode;

  AuthResponse({
    required this.success,
    this.token,
    this.refreshToken,
     this.roles,
    this.user,
    this.error,
    required this.statusCode,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      token: json['token'],
      refreshToken: json['refresh_token'],
        roles: json['role'] != null
          ? List<String>.from(json['role'])
          : null,
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      error: json['error'],
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'refresh_token': refreshToken,
      'user': user?.toJson(),
      'error': error,
      'statusCode': statusCode,
    };
  }
}

/// User Data Model
class UserData {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profilePicture;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePicture,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profilePicture: json['profile_picture'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile_picture': profilePicture,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
