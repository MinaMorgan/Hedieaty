import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, // Set the height of BottomAppBar to a smaller size
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        //notchMargin: 8.0,
        color: Color(0xFF2F3E46), // Dark Slate Gray Background
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 24),
              color: currentIndex == 0 ? Color(0xFF4FC3F7) : Colors.white,
              onPressed: () => onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, size: 24),
              color: currentIndex == 1 ? Color(0xFF4FC3F7) : Colors.white,
              onPressed: () => onItemTapped(1),
            ),
            IconButton(
              icon: const Icon(Icons.notifications, size: 24),
              color: currentIndex == 2 ? Color(0xFF4FC3F7) : Colors.white,
              onPressed: () => onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(Icons.person, size: 24),
              color: currentIndex == 3 ? Color(0xFF4FC3F7) : Colors.white,
              onPressed: () => onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
