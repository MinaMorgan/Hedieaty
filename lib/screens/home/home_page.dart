import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

import '/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;

  final List<Map<String, dynamic>> friends = [
    {'name': 'Mark Zuckerberg', 'eventCount': 3, 'profilePic': 'Assets/images/Mark.jfif'},
    {'name': 'Tim Cook', 'eventCount': 0, 'profilePic': 'Assets/images/Tim.jfif'},
    {'name': 'Jensen Huang', 'eventCount': 1, 'profilePic': 'Assets/images/Jensen.jfif'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Hedieaty'),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E88E5)],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create event or gift list page
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search friends...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(friend['profilePic']),
                    ),
                    title: Text(friend['name']),
                    subtitle: Text(friend['eventCount'] > 0
                        ? 'Upcoming Events: ${friend['eventCount']}'
                        : 'No Upcoming Events'),
                    onTap: () {
                      // Navigate to friend's gift list page or show more details
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
