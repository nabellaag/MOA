import 'package:flutter/material.dart';
import 'package:moa_final_project/models/user.dart';
import 'package:moa_final_project/services/api_service.dart';
import 'package:moa_final_project/services/database_service.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password) async {
    _user = await _apiService.login(email, password);
    if (_user != null) {
      await _databaseService.insertUser(_user!);
      print('User logged in: ${_user!.toJson()}');
    } else {
      print('Login failed');
    }
    notifyListeners();
  }

  Future<void> register(String name, String email, String password, {
    Function()? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    try {
      final result = await _apiService.register(name, email, password);
      print('Register result: $result');
      // Pastikan respons dari API adalah Map<String, dynamic>
      if (result != null && result['error'] == false) {
        onSuccess?.call();
      } else {
        onError?.call(result['message'] ?? 'Failed to register');
      }
    } catch (e) {
      print('Registration error: $e');
      onError?.call('Failed to register: $e');
    }
  }

  Future<void> logout() async {
    _user = null;
    await _apiService.logout();
    await _databaseService.deleteUser();
    notifyListeners();
  }

  Future<void> loadUser() async {
    final user = await _databaseService.getUser();
    if (user != null) {
      _user = user;
      print('Loaded user: ${_user!.toJson()}');
      notifyListeners();
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _apiService.checkEmailExists(email);
      print('Check email exists response: $response');
      return response['error'] ?? true; // Ubah logika sesuai respons API
    } catch (e) {
      print('Check email exists error: $e');
      return false; // Atau handle error sesuai kebutuhan
    }
  }
}
