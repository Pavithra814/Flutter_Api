import 'dart:math';
import 'package:flutter/material.dart';
import 'movie_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;
  late Animation<double> _speedCurve; // controls acceleration speed pattern

  @override
  void initState() {
    super.initState();

    // Animation lasts 3 seconds and plays forward once
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Curve that starts slow and speeds up
    _speedCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic, // slow → fast acceleration
    );

    // Fade & scale animations
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleIn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Start the animation once
    _controller.forward();

    // Move to next screen after animation finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const MovieListScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Shift controls how colors blend across the screen
        final double shift =
            0.25 * (1 + sin(_speedCurve.value * pi)); // starts slow, speeds up

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
               colors: const [
  Color.fromARGB(255, 11, 41, 87), 
  Color.fromARGB(255, 83, 137, 203), 
  Color.fromARGB(255, 5, 78, 174), 
  Color.fromARGB(255, 49, 65, 146), 
],

                stops: [
                  (0.0 + shift).clamp(0.0, 1.0),
                  (0.3 + shift).clamp(0.0, 1.0),
                  (0.6 + shift).clamp(0.0, 1.0),
                  (0.9 + shift).clamp(0.0, 1.0),
                ],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeIn,
                child: ScaleTransition(
                  scale: _scaleIn,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.movie_creation_rounded,
                          color: Colors.white, size: 90),
                      SizedBox(height: 20),
                      Text(
                        'Welcome to Cine World',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '“Where every story lights up the screen.”',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
