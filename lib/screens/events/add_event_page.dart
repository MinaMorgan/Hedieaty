import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/event_controller.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isPublic = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Add New Event'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                TextFormField(
                  key: const Key('titleField'),
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Event Description
                TextFormField(
                  key: const Key('descriptionField'),
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the event description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Event Date Picker
                TextFormField(
                  key: const Key('dateField'),
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    hintText: 'Select a date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select the event date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                // Event Type Toggle (Private/Public)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Event Type',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Text('Private'),
                        Switch(
                          key: const Key('eventTypeSwitch'),
                          value: isPublic,
                          onChanged: (value) {
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
                const SizedBox(height: 24.0),

                // Save Button
                Center(
                  child: ElevatedButton(
                    key: const Key('saveButton'),
                    onPressed: _saveEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Event',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Date Picker Functionality
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  // Save Event Functionality
  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final EventController controller = EventController();

      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final date = dateController.text.trim();

      final result = await controller.createEvent(
        title,
        description,
        date,
        isPublic,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: isPublic
                ? const Text('Event created publicly!')
                : const Text('Event created privately!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event creation failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
