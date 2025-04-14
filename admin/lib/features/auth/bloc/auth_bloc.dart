import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/api_exception.dart';
import '../../../core/services/api_service.dart';
import '../models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;
  final ApiService _apiService;
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  AuthBloc({
    required SharedPreferences prefs,
    required ApiService apiService,
  })  : _prefs = prefs,
        _apiService = apiService,
        super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    final userJson = _prefs.getString(_userKey);
    final token = _prefs.getString(_tokenKey);
    
    if (userJson != null && token != null) {
      try {
        final user = User.fromJson(json.decode(userJson));
        emit(Authenticated(user));
      } catch (e) {
        _clearSession();
        emit(const AuthError('Failed to parse stored user data'));
      }
    } else {
      _clearSession();
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': event.email,
          'password': event.password,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final token = response.data!['token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;
        final user = User.fromJson(userData);
        
        await _prefs.setString(_tokenKey, token);
        await _prefs.setString(_userKey, json.encode(user.toJson()));
        emit(Authenticated(user));
      } else {
        emit(AuthError(response.message ?? 'Login failed'));
      }
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': event.name,
          'email': event.email,
          'password': event.password,
          'role': 'admin',
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final token = response.data!['token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;
        final user = User.fromJson(userData);
        
        await _prefs.setString(_tokenKey, token);
        await _prefs.setString(_userKey, json.encode(user.toJson()));
        emit(Authenticated(user));
      } else {
        emit(AuthError(response.message ?? 'Registration failed'));
      }
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _clearSession();
      emit(Unauthenticated());
    } catch (e) {
      emit(const AuthError('Failed to logout'));
    }
  }

  Future<void> _clearSession() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_tokenKey);
  }
} 