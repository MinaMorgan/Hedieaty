import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import '/screens/profile/profile_page.dart';
import '/widgets/custom_bottom_navigation_bar.dart';

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
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Hedieaty\nWelcome Mina'),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E88E5)],
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



      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
