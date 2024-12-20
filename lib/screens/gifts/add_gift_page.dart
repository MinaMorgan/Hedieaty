import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/gift_controller.dart';

class AddGiftPage extends StatefulWidget {
  final String eventId;
  final bool isPublic;

  const AddGiftPage({
    super.key,
    required this.eventId,
    required this.isPublic,
  });

  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final GiftController controller = GiftController();
  final _formKey = GlobalKey<FormState>();

  final List<String> categories = [
    'Electronics',
    'Toys',
    'Books',
    'Fashion',
    'Home & Living',
    'Health & Beauty',
    'Other',
  ];

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Add New Gift'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gift Name TextField with Key for testing
                TextFormField(
                  key: Key('nameField'),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Gift Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the gift name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Gift Description TextField with Key for testing
                TextFormField(
                  key: Key('descriptionField'),
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
                      return 'Please enter the gift description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Gift Category Dropdown with Key for testing
                DropdownButtonFormField<String>(
                  key: Key('categoryDropdown'),
                  value: selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gift Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select a gift category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Gift Price TextField with Key for testing
                TextFormField(
                  key: Key('priceField'),
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gift Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the gift price';
                    }
                    final parsedValue = int.tryParse(value.trim());
                    if (parsedValue == null || parsedValue <= 0) {
                      return 'Price must be a positive number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                // Create Gift Button with Key for testing
                Center(
                  child: ElevatedButton(
                    key: Key('createButton'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        int price = int.parse(priceController.text.trim());
                        String name = nameController.text.trim();
                        String description = descriptionController.text.trim();

                        if (await controller.createGift(
                          widget.isPublic,
                          widget.eventId,
                          name,
                          description,
                          selectedCategory!,
                          price,
                          true,
                          null,
                          null,
                          null,
                        )) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gift added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context); // Go back to the gift page
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New Gift Creation failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
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
                      'Create Gift',
                      style: TextStyle(fontSize: 16),
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
}
