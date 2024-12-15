import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getEventsByUserId(userId, showFull),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          }
          final events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    event['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(event['description'],
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8.0),
                      Text(
                        'Date: ${event['date']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: showFull
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editEvent(event),
                        )
                      : null,
                  onTap: () {
                    Navigator.pushNamed(context, '/gifts', arguments: {
                      'eventId': event['id'],
                      'eventTitle': event['title'],
                      'showFull': showFull
                    });
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

  Future<void> _editEvent(Map<String, dynamic> event) async {
    // Move isPublic to the State class to handle updates correctly
    bool isPublic = event['isPublic'] == true;

    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: event['title']);
        final descriptionController =
            TextEditingController(text: event['description']);
        final dateController = TextEditingController(text: event['date']);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(labelText: 'Date'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Private'),
                        Switch(
                          value: isPublic,
                          onChanged: (value) {
                            // Use setState from StatefulBuilder to update isPublic
                            setState(() {
                              isPublic = value;
                            });
                          },
                          activeColor: const Color(0xFF1E88E5),
                        ),
                        const Text('Public'),
                      ],
                    ),
                  ],
                ),
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
                        event, title, description, date, isPublic)) {
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
                    if (await controller.deleteEvent(event)) {
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
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
