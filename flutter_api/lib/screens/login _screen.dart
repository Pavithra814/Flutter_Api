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
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  void login() async {
    // ✅ Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => loading = true);
    final user = await AuthApi.login(emailCtrl.text.trim(), passwordCtrl.text.trim());
    setState(() => loading = false);

    if (user != null) {
      await SessionManager.saveUser(user.id, user.name, user.email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MovieListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1,
        title: const Text(
          'Login Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 40),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      backgroundColor: const Color(0xFFF7F9FC),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // LEFT
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Welcome back,",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF2A2A2A),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "\"Movies touch our hearts\nand awaken our vision.\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF636363),
                          fontSize: 20,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // RIGHT
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    width: 420,

                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Sign in",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A2A2A),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // ✅ EMAIL
                            TextFormField(
                              controller: emailCtrl,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade400, width: 1),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 16, 17, 21),
                                      width: 1.6),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!value.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // ✅ PASSWORD
                            TextFormField(
                              controller: passwordCtrl,
                              obscureText: true,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    const TextStyle(color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade400, width: 1),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 2, 2, 3),
                                      width: 1.6),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 4) {
                                  return 'Password must be at least 4 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ✅ LOGIN BUTTON
                            loading
                                ? const Center(child: CircularProgressIndicator())
                                : Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 4, 4, 5),
                                          Color.fromARGB(255, 54, 55, 63),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: login,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: const Text(
                                            "Sign In",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 16),

                            // ✅ REGISTER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 5, 5, 6),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
