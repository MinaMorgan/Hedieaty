import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'update_info_page.dart';
import '/widgets/custom_bottom_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Default to profile tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation for other tabs if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Profile'),
        gradient: const LinearGradient(
        colors: [Color(0xFF1E3A8A), Color(0xFF1E88E5)],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('Assets/images/profile.png'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Mina Morgan',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'mina@example.com',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateInfoPage()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E88E5)),
              child: Text(
                'Edit Profile Information',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: true,
              onChanged: (bool value) {
                // Handle notification toggle
              },
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E88E5)),
              child: Text(
                  'My Pledged Gifts',
                  style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
