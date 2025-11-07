import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import '../screens/login _screen .dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void logout(BuildContext context) async {
    await SessionManager.logout();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SessionManager.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Name: ${user['name']}', style: const TextStyle(fontSize: 20)),
                Text('Email: ${user['email']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => logout(context), child: const Text('Logout')),
              ],
            ),
          ),
        );
      },
    );
  }
}
