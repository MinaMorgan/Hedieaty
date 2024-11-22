import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/screens/gifts/gifts_page.dart';


class EventsPage extends StatelessWidget {
  const EventsPage({super.key});
  // Dummy data for the events list
  static const List<Map<String, String>> events = [
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Events', showButton: true),
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
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
