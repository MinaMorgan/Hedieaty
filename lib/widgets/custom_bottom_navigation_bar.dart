import 'package:flutter/material.dart';


class CustomBottomNavigationBar extends StatelessWidget {

  const CustomBottomNavigationBar({super.key});

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
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            ),
            IconButton(
              icon: const Icon(Icons.card_giftcard, size: 24),
              color: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/events'),
            ),
            IconButton(
              icon: const Icon(Icons.person, size: 24),
              color: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
