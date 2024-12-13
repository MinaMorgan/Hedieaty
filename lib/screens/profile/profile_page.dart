import 'package:flutter/material.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/widgets/gradient_appbar.dart';
import '/services/shared_preferences_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  late String name;
  late String email;
  late String phoneNumber;
  late String photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final userDetails = await sharedPreferences.getUserDetails();
    setState(() {
      name = userDetails['name'];
      email = userDetails['email'];
      phoneNumber = userDetails['phoneNumber'];
      photoUrl = userDetails['photoUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photoUrl),
                ),
                const SizedBox(height: 16.0),
                // User Details
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),
                Text(
                  phoneNumber,
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                ),

                const SizedBox(height: 24.0),

                // Edit Profile Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/updateInfo');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5)),
                  child: const Text(
                    'Edit Profile Information',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16.0),

                // View My Pledged Gifts
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/pledgedGifts', arguments: {
                      'userId': sharedPreferences.getUserId(),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5)),
                  child: const Text(
                    'My Pledged Gifts',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 170.0),

                // Log Out Button
                TextButton(
                  onPressed: () async {
                    await sharedPreferences.clearAll();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
