import 'package:flutter/material.dart';
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
      'title': 'Rotaract Club Meeting',
      'description': 'Join us for our weekly club meeting to discuss upcoming projects and events.',
      'date': '2024-10-25',
    },
    {
      'title': 'Charity Fun Run',
      'description': 'Participate in our annual charity fun run to raise funds for local charities.',
      'date': '2024-11-10',
    },
    {
      'title': 'Tree Planting Event',
      'description': 'Help us make the world greener by planting trees in the community park.',
      'date': '2024-12-05',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                event['title']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),
                  Text(event['description']!, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8.0),
                  Text(
                    'Date: ${event['date']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              onTap: () {
                // Show event details in an AlertDialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(event['title']!),
                    content: Text('More details about "${event['title']}" event.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Set to 1 to highlight the "Events" tab
      ),
    );
  }
}
