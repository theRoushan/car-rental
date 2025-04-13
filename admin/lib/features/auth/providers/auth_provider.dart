import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import '../../../core/models/user.dart';
import '../../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final SharedPreferences _prefs;
  User? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._apiService, this._prefs);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final userData = response.data['user'];

      await _prefs.setString('token', token);
      _currentUser = User.fromJson(userData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final userData = response.data['user'];

      await _prefs.setString('token', token);
      _currentUser = User.fromJson(userData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('token');
    _currentUser = null;
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
      // TODO: Add endpoint to verify token and get user data
      // final response = await _apiService.get('/auth/me');
      // _currentUser = User.fromJson(response.data);
    } catch (e) {
      await logout();
    }
  }
} 