import 'package:flutter/material.dart';
import '../services/auth_api.dart';
import '../services/session_manager.dart';
import 'movie_list_screen.dart';
import 'login _screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool loading = false;

  void register() async {
    // ✅ Validate first
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final user = await AuthApi.register(
      nameCtrl.text,
      emailCtrl.text,
      passCtrl.text,
      confirmCtrl.text,
    );
    setState(() => loading = false);

    if (user != null) {
      await SessionManager.saveUser(user.id, user.name, user.email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MovieListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
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
          'Register Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 40),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MovieListScreen()),
              );
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
              // LEFT QUOTES
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Join Us,",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF2A2A2A),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "\"Discover amazing movies\nand share your favorites.\"",
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

              // RIGHT FORM
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    width: 420,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Sign up",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A2A2A),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // NAME
                            TextFormField(
                              controller: nameCtrl,
                              decoration: _inputStyle("Name"),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Name is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // EMAIL
                            TextFormField(
                              controller: emailCtrl,
                              decoration: _inputStyle("Email"),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Email is required";
                                }
                                final emailRegex = RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                                if (!emailRegex.hasMatch(v)) {
                                  return "Enter valid email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // PASSWORD
                            TextFormField(
                              controller: passCtrl,
                              obscureText: true,
                              decoration: _inputStyle("Password"),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Password is required";
                                }
                                if (v.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // CONFIRM PASSWORD
                            TextFormField(
                              controller: confirmCtrl,
                              obscureText: true,
                              decoration: _inputStyle("Confirm Password"),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Confirm Password is required";
                                }
                                if (v != passCtrl.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // REGISTER BUTTON
                            loading
                                ? const Center(
                                    child: CircularProgressIndicator())
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
                                        onTap: register,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: const Text(
                                            "Register",
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

                            // SIGN IN
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign in",
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

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.6),
      ),
    );
  }
}
