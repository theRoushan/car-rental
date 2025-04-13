import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import '../models/api_response.dart';
import '../models/api_exception.dart';

class ApiService {
  // Use your actual backend URL here
  // static const String baseUrl = 'http://10.0.2.2:8080'; // For Android emulator
  static const String baseUrl = 'http://localhost:8080'; // For iOS simulator
  final Dio dio;
  final SharedPreferences _prefs;

  ApiService(this._prefs) : dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await _prefs.remove('token');
            await _prefs.remove('user');
            // The auth bloc will handle navigation through state changes
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return ApiResponse.fromJson(response.data, fromJson);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final response = await dio.post(path, data: data);
      return ApiResponse.fromJson(response.data, fromJson);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final response = await dio.put(path, data: data);
      return ApiResponse.fromJson(response.data, fromJson);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final response = await dio.delete(path);
      return ApiResponse.fromJson(response.data, fromJson);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
} 