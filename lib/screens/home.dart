import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> friends = [
    {'name': 'Mark Zuckerberg', 'hasUpcomingEvents': true, 'profilePic': 'Assets/images/Mark.jfif'},
    {'name': 'Tim Cook', 'hasUpcomingEvents': false, 'profilePic': 'https://via.placeholder.com/150'},
    {'name': 'Jensen Huang', 'hasUpcomingEvents': true, 'profilePic': 'https://via.placeholder.com/150'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hedieaty\nWelcome Mina'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to create event or gift list page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: friends[index]['profilePic'].startsWith('http')
                        ? NetworkImage(friends[index]['profilePic'])
                        : AssetImage(friends[index]['profilePic']) as ImageProvider,
                  ),
                  title: Text(friends[index]['name']),
                  subtitle: Text(friends[index]['hasUpcomingEvents']
                      ? 'Upcoming Events: 1'
                      : 'No Upcoming Events'),
                  onTap: () {
                    // Navigate to friend's gift list page
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to create a new event or gift list
        },
        child: Icon(Icons.create),
        tooltip: 'Create Your Own Event/List',
      ),
    );
  }
}
