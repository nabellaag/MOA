import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moa_final_project/viewmodels/auth_viewmodel.dart';
import 'package:moa_final_project/views/home_screen.dart';
import 'package:moa_final_project/views/login_screen.dart';
import 'package:moa_final_project/views/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel()..loadUser(),
      child: MaterialApp(
        title: 'Story App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              if (authViewModel.user != null) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
