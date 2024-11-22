import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/screens/gifts/pledged_gifts_page.dart';
import 'update_info_page.dart';

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
      appBar: const GradientAppBar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('Assets/images/profile.png'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Mina Morgan',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'mina@example.com',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateInfoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5)),
              child: const Text(
                'Edit Profile Information',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: true,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF1E88E5),
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5)),
              child: const Text(
                'My Pledged Gifts',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child:
                  Container(), // Or other content to fill the remaining space
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              //style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Log Out',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
