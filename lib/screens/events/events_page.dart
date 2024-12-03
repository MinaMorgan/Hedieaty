import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/screens/gifts/gifts_page.dart';
import '/controller/event_controller.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late String userId;
  late bool showFull;
  final EventController controller = EventController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userId = args['userId'];
    showFull = args['showFull'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Events',
        showButton: showFull,
        onButtonPressed: () {
          Navigator.pushNamed(context, '/addEvent');
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getEventsByUserId(userId),
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(eventData['description'],
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8.0),
                      Text(
                        'Date: ${eventData['date']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: showFull
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editEvent(eventId, eventData),
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GiftsPage(eventTitle: eventData['title']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: showFull ? CustomBottomNavigationBar() : null,
    );
  }

  Future<void> _editEvent(
      String eventId, Map<String, dynamic> eventData) async {
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
                String title = titleController.text;
                String description = descriptionController.text;
                String date = dateController.text;

                if (await controller.editEvent(
                    eventId, title, description, date)) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Updating Event failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
                onPressed: () async {
                  // Validate the form
                  if (await deleteEvent(eventId)) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Deleting Event failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)))
          ],
        );
      },
    );
  }

  Future<bool> deleteEvent(String eventId) async {
    return await controller.deleteEvent(eventId);
  }
}
