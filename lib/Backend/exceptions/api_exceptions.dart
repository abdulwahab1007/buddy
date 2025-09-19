/// API Exception Classes
/// Custom exception handling for API operations

/// Base API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final String? errorCode;

  ApiException(
    this.message, {
    this.statusCode,
    this.data,
    this.errorCode,
  });

  @override
  String toString() => 'ApiException: $message';
}

/// Network Exception
class NetworkException extends ApiException {
  NetworkException(String message) : super(message, statusCode: 0);
}

/// Authentication Exception
class AuthenticationException extends ApiException {
  AuthenticationException(String message) : super(message, statusCode: 401);
}

/// Authorization Exception
class AuthorizationException extends ApiException {
  AuthorizationException(String message) : super(message, statusCode: 403);
}

/// Validation Exception
class ValidationException extends ApiException {
  final Map<String, List<String>>? validationErrors;

  ValidationException(
    String message, {
    this.validationErrors,
  }) : super(message, statusCode: 422);
}

/// Not Found Exception
class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

/// Server Exception
class ServerException extends ApiException {
  ServerException(String message) : super(message, statusCode: 500);
}

/// Timeout Exception
class TimeoutException extends ApiException {
  TimeoutException(String message) : super(message, statusCode: 408);
}

/// Bad Request Exception
class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, statusCode: 400);
}

/// Conflict Exception
class ConflictException extends ApiException {
  ConflictException(String message) : super(message, statusCode: 409);
}

/// Too Many Requests Exception
class TooManyRequestsException extends ApiException {
  TooManyRequestsException(String message) : super(message, statusCode: 429);
}

/// Service Unavailable Exception
class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException(String message) : super(message, statusCode: 503);
}

/// Payment Required Exception
class PaymentRequiredException extends ApiException {
  PaymentRequiredException(String message) : super(message, statusCode: 402);
}

/// Forbidden Exception
class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, statusCode: 403);
}

/// Method Not Allowed Exception
class MethodNotAllowedException extends ApiException {
  MethodNotAllowedException(String message) : super(message, statusCode: 405);
}

/// Not Acceptable Exception
class NotAcceptableException extends ApiException {
  NotAcceptableException(String message) : super(message, statusCode: 406);
}

/// Unsupported Media Type Exception
class UnsupportedMediaTypeException extends ApiException {
  UnsupportedMediaTypeException(String message) : super(message, statusCode: 415);
}

/// Unprocessable Entity Exception
class UnprocessableEntityException extends ApiException {
  UnprocessableEntityException(String message) : super(message, statusCode: 422);
}

/// Locked Exception
class LockedException extends ApiException {
  LockedException(String message) : super(message, statusCode: 423);
}

/// Failed Dependency Exception
class FailedDependencyException extends ApiException {
  FailedDependencyException(String message) : super(message, statusCode: 424);
}

/// Upgrade Required Exception
class UpgradeRequiredException extends ApiException {
  UpgradeRequiredException(String message) : super(message, statusCode: 426);
}

/// Precondition Required Exception
class PreconditionRequiredException extends ApiException {
  PreconditionRequiredException(String message) : super(message, statusCode: 428);
}

/// Request Header Fields Too Large Exception
class RequestHeaderFieldsTooLargeException extends ApiException {
  RequestHeaderFieldsTooLargeException(String message) : super(message, statusCode: 431);
}

/// Unavailable For Legal Reasons Exception
class UnavailableForLegalReasonsException extends ApiException {
  UnavailableForLegalReasonsException(String message) : super(message, statusCode: 451);
}

/// Internal Server Error Exception
class InternalServerErrorException extends ApiException {
  InternalServerErrorException(String message) : super(message, statusCode: 500);
}

/// Not Implemented Exception
class NotImplementedException extends ApiException {
  NotImplementedException(String message) : super(message, statusCode: 501);
}

/// Bad Gateway Exception
class BadGatewayException extends ApiException {
  BadGatewayException(String message) : super(message, statusCode: 502);
}

/// Gateway Timeout Exception
class GatewayTimeoutException extends ApiException {
  GatewayTimeoutException(String message) : super(message, statusCode: 504);
}

/// HTTP Version Not Supported Exception
class HttpVersionNotSupportedException extends ApiException {
  HttpVersionNotSupportedException(String message) : super(message, statusCode: 505);
}

/// Variant Also Negotiates Exception
class VariantAlsoNegotiatesException extends ApiException {
  VariantAlsoNegotiatesException(String message) : super(message, statusCode: 506);
}

/// Insufficient Storage Exception
class InsufficientStorageException extends ApiException {
  InsufficientStorageException(String message) : super(message, statusCode: 507);
}

/// Loop Detected Exception
class LoopDetectedException extends ApiException {
  LoopDetectedException(String message) : super(message, statusCode: 508);
}

/// Not Extended Exception
class NotExtendedException extends ApiException {
  NotExtendedException(String message) : super(message, statusCode: 510);
}

/// Network Authentication Required Exception
class NetworkAuthenticationRequiredException extends ApiException {
  NetworkAuthenticationRequiredException(String message) : super(message, statusCode: 511);
}

/// Exception Factory
class ApiExceptionFactory {
  static ApiException createException(int statusCode, String message, {dynamic data}) {
    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return AuthenticationException(message);
      case 402:
        return PaymentRequiredException(message);
      case 403:
        return AuthorizationException(message);
      case 404:
        return NotFoundException(message);
      case 405:
        return MethodNotAllowedException(message);
      case 406:
        return NotAcceptableException(message);
      case 408:
        return TimeoutException(message);
      case 409:
        return ConflictException(message);
      case 415:
        return UnsupportedMediaTypeException(message);
      case 422:
        return ValidationException(message);
      case 423:
        return LockedException(message);
      case 424:
        return FailedDependencyException(message);
      case 426:
        return UpgradeRequiredException(message);
      case 428:
        return PreconditionRequiredException(message);
      case 429:
        return TooManyRequestsException(message);
      case 431:
        return RequestHeaderFieldsTooLargeException(message);
      case 451:
        return UnavailableForLegalReasonsException(message);
      case 500:
        return InternalServerErrorException(message);
      case 501:
        return NotImplementedException(message);
      case 502:
        return BadGatewayException(message);
      case 503:
        return ServiceUnavailableException(message);
      case 504:
        return GatewayTimeoutException(message);
      case 505:
        return HttpVersionNotSupportedException(message);
      case 506:
        return VariantAlsoNegotiatesException(message);
      case 507:
        return InsufficientStorageException(message);
      case 508:
        return LoopDetectedException(message);
      case 510:
        return NotExtendedException(message);
      case 511:
        return NetworkAuthenticationRequiredException(message);
      default:
        return ServerException(message);
    }
  }
}
