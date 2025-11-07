import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveUser(int id, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    final name = prefs.getString('userName');
    final email = prefs.getString('userEmail');
    if (id != null && name != null && email != null) {
      return {'id': id, 'name': name, 'email': email};
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
