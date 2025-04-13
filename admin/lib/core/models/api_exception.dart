import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final List<String>? errors;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
    this.originalError,
  });

  factory ApiException.fromDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(
            message: 'Connection timeout. Please check your internet connection.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.badResponse:
          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            return ApiException(
              message: data['message'] ?? 'An error occurred',
              statusCode: error.response?.statusCode,
              errors: data['errors'] != null ? List<String>.from(data['errors']) : null,
            );
          }
          return ApiException(
            message: 'Server error occurred',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.cancel:
          return ApiException(message: 'Request cancelled');
        case DioExceptionType.unknown:
          return ApiException(
            message: 'An unexpected error occurred',
            originalError: error,
          );
        default:
          return ApiException(
            message: 'Something went wrong',
            originalError: error,
          );
      }
    }
    return ApiException(
      message: 'An unexpected error occurred',
      originalError: error,
    );
  }

  @override
  String toString() => message;
} 