import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import '../screens/login _screen.dart';
import '../screens/profile _screen.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final bool showBackButton;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.showBackButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final u = await SessionManager.getUser();
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: false,
      leading: widget.showBackButton? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ):null,
      title: Row(
        children: [
          // Your image icon
          // Image.asset(
          //   "assets/logo.png",  
          //   height: 28,
          // ),
          // const SizedBox(width: 10),
          const Text(
            'Cine World',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const Spacer(),

          // SEARCH FIELD
          SizedBox(
            width: 200,
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.white54),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                    final query = widget.controller.text.trim();
                    if (query.isNotEmpty) {
                      widget.onSearch(query);
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              onSubmitted: (value) {
                final query = value.trim();
                if (query.isNotEmpty) {
                  widget.onSearch(query);
                }
                FocusScope.of(context).unfocus();
              },
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              if (user == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ).then((_) => loadUser());
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
            },
            child: user == null
                ? const Icon(Icons.person, color: Colors.white, size: 35)
                : Tooltip(
                    message: user!['name'] ?? "",
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Text(
                        user!['name'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
