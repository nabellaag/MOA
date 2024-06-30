import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moa_final_project/viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    void _logout() async {
      await authViewModel.logout();
      Navigator.pushReplacementNamed(context, '/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(child: Text('Welcome ${authViewModel.user?.name ?? ''}')),
    );
  }
}
