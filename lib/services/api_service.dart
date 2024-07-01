import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moa_final_project/models/user.dart';
import 'package:moa_final_project/models/story.dart'; // Add this import
import 'dart:io'; // Add this import

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://story-api.dicoding.dev/v1'));

  Future<User?> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');

      if (response.statusCode == 200 && response.data['error'] == false) {
        final loginResult = response.data['loginResult'];
        if (loginResult != null) {
          final user = User.fromJson(loginResult);
          await saveToken(user.token);
          return user;
        } else {
          print('Login failed: loginResult is null');
          return null;
        }
      } else {
        print('Login failed: ${response.data['message']}');
        return null;
      }
    } catch (e) {
      print('Login error: $e'); // Log error
      return null;
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      print('Register response status: ${response.statusCode}');
      print('Register response data: ${response.data}');

      if (response.statusCode == 201) {
        // Registration successful
        return {
          'error': false,
          'message': 'Registration successful',
        };
      } else {
        // Registration failed, but server responded
        return {
          'error': response.data['error'] ?? true, // Ensure boolean, default true if null
          'message': response.data['message'] ?? 'Unknown error', // Default message if null
        };
      }
    } catch (e) {
      print('Register error: $e');
      return {
        'error': true,
        'message': 'Registration failed: $e',
      };
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, dynamic>> checkEmailExists(String email) async {
    try {
      final response = await _dio.get('/check-email', queryParameters: {'email': email});
      print('Check email response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('Check email error: $e');
      throw e; // Handle error accordingly
    }
  }

  Future<List<Story>> getAllStories() async {
    final token = await getToken();
    try {
      final response = await _dio.get(
        '/stories',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('Get all stories response data: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['listStory'];
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stories');
      }
    } catch (e) {
      print('Get all stories error: $e');
      throw e;
    }
  }
  Future<void> deleteStory(String storyId) async {
    final token = await getToken();
    try {
      final response = await _dio.delete(
        '/stories/$storyId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('Delete story response data: ${response.data}');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete story');
      }
    } catch (e) {
      print('Delete story error: $e');
      throw e;
    }
  }
  Future<void> addStory(String description, File photo) async {
    final token = await getToken();
    try {
      FormData formData = FormData.fromMap({
        'description': description,
        'photo': await MultipartFile.fromFile(photo.path, filename: 'upload.jpg'),
      });
      final response = await _dio.post(
        '/stories',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('Add story response data: ${response.data}');
      if (response.statusCode != 201) {
        throw Exception('Failed to add story');
      }
    } catch (e) {
      print('Add story error: $e');
      throw e;
    }
  }
}
