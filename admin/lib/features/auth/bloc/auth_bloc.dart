import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;
  static const String _userKey = 'user';

  AuthBloc({required SharedPreferences prefs})
      : _prefs = prefs,
        super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(json.decode(userJson));
        emit(Authenticated(user));
      } catch (e) {
        emit(const AuthError('Failed to parse stored user data'));
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: Implement actual login API call
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 2));
      
      final user = User(
        id: '1',
        name: 'Admin User',
        email: event.email,
        role: 'admin',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      await _prefs.setString(_userKey, json.encode(user.toJson()));
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: Implement actual registration API call
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 2));
      
      final user = User(
        id: '1',
        name: event.name,
        email: event.email,
        role: 'admin',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      await _prefs.setString(_userKey, json.encode(user.toJson()));
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _prefs.remove(_userKey);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
} 