import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  final TextEditingController _emailController = TextEditingController();

  final List<Map<String, dynamic>> friends = [
    {
      'name': 'Mark Zuckerberg',
      'eventCount': 3,
      'profilePic': 'Assets/images/Mark.jfif'
    },
    {
      'name': 'Tim Cook',
      'eventCount': 0,
      'profilePic': 'Assets/images/Tim.jfif'
    },
    {
      'name': 'Jensen Huang',
      'eventCount': 1,
      'profilePic': 'Assets/images/Jensen.jfif'
    },
  ];

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Enter Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your friend-adding logic here
                print('Adding friend with email: ${_emailController.text}');
                Navigator.pop(context); // Close the dialog
                _emailController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "Hedieaty", showButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}