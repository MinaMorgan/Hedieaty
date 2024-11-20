import 'package:flutter/material.dart';

import '/screens/home/home_page.dart';
import '/screens/event/events_page.dart';
import '/screens/profile/profile_page.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _navigateToPage(BuildContext context, int index) {
    // Navigate to different pages based on the index
    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = const HomePage(); // Adjust to the correct home page import if needed
        break;
      case 1:
        targetPage = const EventsPage(); // Events page
        break;
      case 2:
        targetPage = const ProfilePage(); // Profile page
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

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
              color: currentIndex == 0 ? Color(0xFF4FC3F7) : Colors.white,
              onPressed: () => _navigateToPage(context, 0),
            ),
            IconButton(
              icon: const Icon(Icons.card_giftcard, size: 24),
              color: currentIndex == 1 ? Color(0xFF4FC3F7) : Colors.white,
              onPressed: () => _navigateToPage(context, 1),
            ),
            IconButton(
              icon: const Icon(Icons.person, size: 24),
              color: currentIndex == 2 ? Color(0xFF4FC3F7) : Colors.white,
              onPressed: () => _navigateToPage(context, 2),
            ),
          ],
        ),
      ),
    );
  }
}
