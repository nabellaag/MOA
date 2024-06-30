import 'package:flutter/material.dart';
import 'package:moa_final_project/models/user.dart';
import 'package:moa_final_project/services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password) async {
    _user = await _apiService.login(email, password);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _user = await _apiService.register(name, email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await _apiService.logout();
    notifyListeners();
  }

  Future<void> loadUser() async {
    final token = await _apiService.getToken();
    if (token != null) {
      _user = User(id: '', name: '', email: '', token: token);
      notifyListeners();
    }
  }
}
