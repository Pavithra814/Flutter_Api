import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login _screen .dart';
import 'screens/register_screen.dart';
// import 'screens/home_screen.dart';

void main() {
  runApp(const CineWorldApp());
}

class CineWorldApp extends StatelessWidget {
  const CineWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cine World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        // '/home': (_) => const HomeScreen(),
      },
    );
  }
}
