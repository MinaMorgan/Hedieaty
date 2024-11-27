import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/screens/gifts/pledged_gifts_page.dart';
import 'update_info_page.dart';
import '/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Profile'),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firebaseService.getUserDetails(), // Fetch user details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No user data available'));
          }

          // Fetch user details from Firestore
          var userData = snapshot.data!.data();
          String name = userData?['name'] ?? 'User Name';
          String email = userData?['email'] ?? 'Email not available';
          String? photoURL = userData?['photoURL'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: photoURL != null
                      ? NetworkImage(photoURL) // Show Firebase profile photo if available
                      : const AssetImage('assets/images/profile.png') as ImageProvider,
                ),
                const SizedBox(height: 16.0),
                Text(
                  name,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
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
                  onPressed: () async {
                    await firebaseService.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    'Log Out',
                    style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
