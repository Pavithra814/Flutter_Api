import 'package:flutter/material.dart';
import '../services/auth_api.dart';
import '../services/session_manager.dart';
import 'movie_list_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool loading = false;

  void login() async {
    setState(() => loading = true);
    final user = await AuthApi.login(emailCtrl.text, passwordCtrl.text);
    setState(() => loading = false);

    if (user != null) {
      await SessionManager.saveUser(user.id, user.name, user.email);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MovieListScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: login, child: const Text('Login')),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              child: const Text('Don’t have an account? Register'),
            )
          ],
        ),
      ),
    );
  }
}
