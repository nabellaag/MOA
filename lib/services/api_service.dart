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
      final user = User.fromJson(response.data['loginResult']);
      await saveToken(user.token);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      final user = User.fromJson(response.data['loginResult']);
      await saveToken(user.token);
      return user;
    } catch (e) {
      print(e);
      return null;
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
}