import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

import 'update_info_page.dart';
import '/screens/gifts/pledged_gifts_page.dart';
import '/widgets/custom_bottom_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _selectedIndex = 3; // Default to profile tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Profile'),
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
              title: const Text('Enable Notifications'),
              value: true,
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF1E88E5),
              onChanged: (bool value) {
                // Handle notification toggle
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PledgedGiftsPage()),
                );
              },

              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E88E5)),
              child: const Text(
                  'My Pledged Gifts',
                  style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: Container(), // Or other content to fill the remaining space
            ),
            TextButton(
                onPressed: () {},
                //style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
