import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moa_final_project/models/user.dart';

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
        final user = User.fromJson(response.data['loginResult']);
        await saveToken(user.token);
        return user;
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
      print('Register response data: ${response.data}');
      return {
        'error': response.data['error'] ?? true, // Pastikan boolean, default true jika null
        'message': response.data['message'] ?? 'Unknown error', // Default message jika null
      };
    } catch (e) {
      print('Register error: $e');
      throw e; // Handle error accordingly
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
}
