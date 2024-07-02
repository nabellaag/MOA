import 'package:flutter/material.dart';
import 'package:moa_final_project/models/user.dart';
import 'package:moa_final_project/services/api_service.dart';
import 'package:moa_final_project/services/database_service.dart';
import 'package:moa_final_project/models/story.dart'; // Ensure this import is added
import 'dart:io'; // Ensure this import is added

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password, {
    required Function(User user) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      final user = await _apiService.login(email, password);
      if (user != null) {
        onSuccess(user);
      } else {
        onError('Login failed');
      }
    } catch (e) {
      print('Login error: $e');
      onError('Login failed: $e');
    }
  }

  Future<void> register(String name, String email, String password, {
    Function()? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    try {
      final result = await _apiService.register(name, email, password);
      print('Register result: $result');
      if (result != null && result['error'] == false) {
        onSuccess?.call();
      } else {
        print('Registration failed with message: ${result['message']}');
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

  List<Story> _stories = [];
  List<Story> get stories => _stories;

  Future<void> fetchStories() async {
    try {
      _stories = await _apiService.getAllStories();
      notifyListeners();
    } catch (e) {
      print('Fetch stories error: $e');
    }
  }
  Future<void> addStory(String description, File photo, {
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      await _apiService.addStory(description, photo);
      onSuccess();
    } catch (e) {
      print('Add story error: $e');
      onError(e.toString());  // Pass the exception message directly
    }
  }
  Future<void> deleteStory(String storyId, {
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      await _apiService.deleteStory(storyId);
      await fetchStories(); // Refresh stories after deletion
      onSuccess();
    } catch (e) {
      print('Delete story error: $e');
      onError('Failed to delete story: $e');
    }
  }
}
