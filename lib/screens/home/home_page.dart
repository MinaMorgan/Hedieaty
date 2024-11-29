import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> friends = [
    {
      'name': 'Mark Zuckerberg',
      'eventCount': 3,
      'profilePic': 'assets/images/profile.png'
    },
    {
      'name': 'Tim Cook',
      'eventCount': 0,
      'profilePic': 'assets/images/profile.png'
    },
    {
      'name': 'Jensen Huang',
      'eventCount': 1,
      'profilePic': 'assets/images/profile.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Hedieaty',
        showButton: true,
        onButtonPressed: () {
          Navigator.pushNamed(context, '/addFriend');
        },
      ),
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
