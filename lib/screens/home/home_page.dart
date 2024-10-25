import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

import '/screens/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> friends = [
    {'name': 'Mark Zuckerberg', 'eventCount': 3, 'profilePic': 'Assets/images/Mark.jfif'},
    {'name': 'Tim Cook', 'eventCount': 0, 'profilePic': 'Assets/images/Tim.jfif'},
    {'name': 'Jensen Huang', 'eventCount': 1, 'profilePic': 'Assets/images/Jensen.jfif'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Hedieaty\nWelcome Mina'),
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E88E5)], // Deep blue to soft teal
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
                  prefixIcon: Icon(Icons.search),
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
                      backgroundImage: AssetImage(friend['profilePic']) as ImageProvider,
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



      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Action for the central floating button
      //   },
      //   child: Icon(Icons.add),
      //   tooltip: 'Create New Event/List',
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      bottomNavigationBar: SizedBox(
        height: 56, // Set the height of BottomAppBar to a smaller size
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          //notchMargin: 8.0,
          color: Color(0xFF2F3E46), // Dark Slate Gray Background
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, size: 24), // Reduced icon size for a smaller BottomAppBar
                color: _selectedIndex == 0 ? Color(0xFF4FC3F7) : Colors.white,
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(Icons.favorite, size: 24),
                color: _selectedIndex == 1 ? Color(0xFF4FC3F7) : Colors.white,
                onPressed: () => _onItemTapped(1),
              ),
              //SizedBox(width: 40), // Placeholder for the FAB
              IconButton(
                icon: Icon(Icons.notifications, size: 24),
                color: _selectedIndex == 2 ? Color(0xFF4FC3F7) : Colors.white,
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(Icons.person, size: 24),
                color: _selectedIndex == 3 ? Color(0xFF4FC3F7) : Colors.white,
                onPressed: () => ProfilePage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
