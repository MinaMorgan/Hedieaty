import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/screens/events/add_event_page.dart';
import '/controller/event_controller.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late String userId;
  late bool showFull;

  final EventController _controller = EventController();

  // Sorting, Filtering, and Day Variables
  String _selectedSortOption = 'Title';
  String _selectedDayFilter = 'All';
  final List<String> sortOptions = ['Title', 'Date'];
  final List<String> dayFilters = ['All', 'Upcoming', 'Current', 'Past'];

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
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddEventPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
      ),
      body: Column(
        children: [
          // Sorting and Filtering UI
          Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sorting Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sort By:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSortOption,
                            icon: const Icon(Icons.sort,
                                color: Colors.blueAccent),
                            isExpanded: true,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSortOption = newValue!;
                              });
                            },
                            items: sortOptions.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Day Filter Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter by Day:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDayFilter,
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.blueAccent),
                            isExpanded: true,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDayFilter = newValue!;
                              });
                            },
                            items: dayFilters
                                .map<DropdownMenuItem<String>>(
                                  (String dayFilter) =>
                                      DropdownMenuItem<String>(
                                    value: dayFilter,
                                    child: Text(dayFilter),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Event List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _controller.getEventsByUserId(userId, showFull),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No events found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // Apply sorting and filtering
                final events = _controller.filterAndSortEvents(snapshot.data!, _selectedSortOption, _selectedDayFilter);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        title: Text(
                          event['title'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              event['description'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.date_range,
                                    size: 16, color: Colors.blueAccent),
                                const SizedBox(width: 4),
                                Text(
                                  'Date: ${event['date']}',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: showFull
                            ? IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                onPressed: () => _editEvent(event),
                              )
                            : null,
                        onTap: () {
                          Navigator.pushNamed(context, '/gifts', arguments: {
                            'eventId': event['id'],
                            'eventTitle': event['title'],
                            'eventIsPublic': event['isPublic'],
                            'showFull': showFull
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: showFull ? CustomBottomNavigationBar() : null,
    );
  }

  Future<void> _editEvent(Map<String, dynamic> event) async {
    bool updatedIsPublic = event['isPublic'];

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
                          value: updatedIsPublic,
                          onChanged: (value) {
                            setState(() {
                              updatedIsPublic = value;
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
                    String updatedTitle = titleController.text;
                    String updatedDescription = descriptionController.text;
                    String updatedDate = dateController.text;

                    if (await _controller.editEvent(event, updatedTitle,
                        updatedDescription, updatedDate, updatedIsPublic)) {
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
                    if (await _controller.deleteEvent(
                        event['isPublic'], event['id'])) {
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
