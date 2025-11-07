// widgets/search_appbar.dart
import 'package:flutter/material.dart';
// import '../screens/auth_service.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchAppBar({super.key, required this.controller, required this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          const Text(
            'Cine World',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 200,
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.white54),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                isDense: true,
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    onSearch(controller.text);
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              onSubmitted: (value) {
                onSearch(value);
                controller.clear();
                FocusScope.of(context).unfocus();
              },
            ),
          ),

  //         IconButton(
  //   icon: const Icon(Icons.login),
  //   tooltip: 'Login (optional)',
  //   onPressed: () {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => const AuthScreen()),
  //     );
  //   },
  // ),
        ],
      ),
    );
  }
}
