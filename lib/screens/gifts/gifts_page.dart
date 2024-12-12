import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/gift_controller.dart';

class GiftsPage extends StatefulWidget {
  const GiftsPage({super.key});

  @override
  _GiftsPageState createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  late String eventId;
  late String eventTitle;
  late bool showFull;
  final GiftController controller = GiftController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    eventId = args['eventId'];
    eventTitle = args['eventTitle'];
    showFull = args['showFull'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Gifts for $eventTitle',
        showButton: showFull,
        onButtonPressed: () {
          Navigator.pushNamed(context, '/addGift', arguments: eventId);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getGiftsByEventId(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No gifts found.'));
          }
          final gifts = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              final giftId = gift.id;
              final giftData = gift.data() as Map<String, dynamic>;

              Color textColor =
                  (giftData['status'] == true) ? Colors.green : Colors.red;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    giftData['name'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  subtitle: Text(giftData['description']),
                  trailing: (showFull && giftData['status'])
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editGift(giftId, giftData),
                        )
                      : null,
                  onTap: () {
                    Navigator.pushNamed(context, '/giftDetails', arguments: {
                      'giftId': giftId,
                      'allowPledge': !showFull
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _editGift(String giftId, Map<String, dynamic> giftData) async {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: giftData['name']);
        final descriptionController =
            TextEditingController(text: giftData['description']);
        final categoryController =
            TextEditingController(text: giftData['category']);
        final priceController =
            TextEditingController(text: giftData['price'].toString());

        return AlertDialog(
          title: const Text('Edit Gift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
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
                String name = nameController.text;
                String description = descriptionController.text;
                String category = categoryController.text;
                int price = int.parse(priceController.text.trim());

                if (await controller.editGift(
                    giftId, eventId, name, description, category, price)) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Updating Gift failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () async {
                if (await controller.deleteGift(giftId)) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Deleting Gift failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
