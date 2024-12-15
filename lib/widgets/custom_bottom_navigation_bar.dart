import 'package:flutter/material.dart';
import '/services/shared_preferences_manager.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({super.key});
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, // Set the height of BottomAppBar to a smaller size
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF2F3E46), // Dark Slate Gray Background
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 24),
              color: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            IconButton(
              icon: const Icon(Icons.card_giftcard, size: 24),
              color: Colors.white,
              onPressed: () async {
                String userId = await sharedPreferences.getUserId();
                Navigator.pushReplacementNamed(context, '/events',
                    arguments: {'userId': userId, 'showFull': true});
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, size: 24),
              color: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/notifications'),
            ),
            IconButton(
              icon: const Icon(Icons.person, size: 24),
              color: Colors.white,
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
