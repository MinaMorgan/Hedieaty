import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

import '/screens/event/add_event_page.dart';
import '/screens/gifts/gifts_page.dart';
import '/widgets/custom_bottom_navigation_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  // Dummy data for the events list
  final List<Map<String, String>> events = [
    {
      'title': 'My Birthday Celebration',
      'description':
      'Celebrating my birthday with close friends and family. I would love thoughtful gifts like books, tech gadgets, or even handmade items.',
      'date': '2024-10-30',
    },
    {
      'title': 'Graduation Party',
      'description':
      'It’s finally graduation day! If you’re thinking of bringing a gift, I’d appreciate anything memorable, like photo albums, personalized items, or even something for my new apartment.',
      'date': '2025-01-15',
    },
    {
      'title': 'Engagement Celebration',
      'description':
      'Join us in celebrating my engagement! If you’re considering a gift, something for our new life together like dinnerware or bedding would be perfect.',
      'date': '2025-03-10',
    }
  ];

  void _addNewEvent() {
    // Navigate to the AddEventPage to add a new event
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Events'),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E88E5)],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addNewEvent();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                event['title']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4.0),
                  Text(event['description']!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8.0),
                  Text(
                    'Date: ${event['date']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              onTap: () {
                // Navigate to GiftsPage and pass event data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftsPage(eventTitle: event['title']!),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 1, // Set to 1 to highlight the "Events" tab
      ),
    );
  }
}
