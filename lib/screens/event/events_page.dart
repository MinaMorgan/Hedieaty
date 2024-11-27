import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/screens/gifts/gifts_page.dart';
import '/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final CollectionReference eventsCollection =
  FirebaseFirestore.instance.collection('events');
  

  Future<void> _editEvent(String eventId, Map<String, dynamic> eventData) async {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: eventData['title']);
        final descriptionController =
        TextEditingController(text: eventData['description']);
        final dateController = TextEditingController(text: eventData['date']);

        return AlertDialog(
          title: const Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedEvent = {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'date': dateController.text,
                };
                await firebaseService.editEvent(eventId, updatedEvent);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () async {
                await firebaseService.removeEvent(eventId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Events',
        showButton: true
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found.'));
          }
          final events = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventId = event.id;
              final eventData = event.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    eventData['title'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(eventData['description'], style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8.0),
                      Text(
                        'Date: ${eventData['date']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editEvent(eventId, eventData),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftsPage(eventTitle: eventData['title']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
