import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty/services/shared_preferences_manager.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/gift_controller.dart';

class GiftDetailsPage extends StatefulWidget {
  const GiftDetailsPage({super.key});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  late String giftId;
  late bool allowPledge;
  final GiftController controller = GiftController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    giftId = args['giftId'];
    allowPledge = args['allowPledge'];
  }

  void _pledgeGift() async {
    String userId = await sharedPreferences.getUserId();

    // Update the gift status to pledged
    await controller.pledgeGift(giftId, userId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gift successfully pledged!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Gift Details',
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: controller.getGiftById(giftId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Gift not found.'));
          }

          // Real-time gift data
          final giftData = snapshot.data!.data() as Map<String, dynamic>;

          final String name = giftData['name'];
          final String description = giftData['description'];
          final String category = giftData['category'];
          final int price = giftData['price'];
          final bool status = giftData['status'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Description:',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Category:',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  category,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Price:',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '\$$price',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      status ? 'Available' : 'Pledged',
                      style: TextStyle(
                        fontSize: 16,
                        color: status ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                // Pledge Button
                if (allowPledge && status)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _pledgeGift,
                      icon: const Icon(Icons.volunteer_activism,
                          color: Colors.white),
                      label: const Text(
                        'Pledge Gift',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
