import 'package:flutter/material.dart';
import 'update_info_page.dart';

class ProfilePage extends StatelessWidget {
  // Dummy data for user profile
  final String userName = 'Mina';
  final String userEmail = 'mina@example.com';
  final String userProfilePic = 'assets/images/profile_pic.jpg'; // Make sure this image exists

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(userProfilePic),
            ),
            SizedBox(height: 16.0),
            Text(
              userName,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              userEmail,
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            // Inside ProfilePage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateInfoPage()),
                );
              },
              child: Text('Update Personal Information'),
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: true, // Assuming notifications are enabled
              onChanged: (bool value) {
                // Handle notification setting change
              },
            ),
          ],
        ),
      ),
    );
  }
}
