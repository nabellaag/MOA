import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moa_final_project/viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      await Provider.of<AuthViewModel>(context, listen: false).login(
        _emailController.text,
        _passwordController.text,
      );
      if (Provider.of<AuthViewModel>(context, listen: false).user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter password' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
