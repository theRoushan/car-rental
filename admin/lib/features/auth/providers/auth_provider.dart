import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import '../models/user.dart';
import '../../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final SharedPreferences _prefs;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._apiService, this._prefs);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final token = response.data!['token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;
        final user = User.fromJson(userData);
        
        await _prefs.setString('token', token);
        _currentUser = user;
        _error = null;
      } else {
        _error = response.message ?? 'Login failed';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': 'admin',
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final token = response.data!['token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;
        final user = User.fromJson(userData);
        
        await _prefs.setString('token', token);
        _currentUser = user;
        _error = null;
      } else {
        _error = response.message ?? 'Registration failed';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('token');
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = _prefs.getString('token');
    if (token == null) {
      _currentUser = null;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.get<User>(
        '/auth/me',
        fromJson: (json) => User.fromJson(json),
      );

      if (response.success && response.data != null) {
        _currentUser = response.data;
        _error = null;
      } else {
        await logout();
        _error = response.message ?? 'Session expired';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      await logout();
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
} 