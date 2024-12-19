import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/gift_controller.dart';

class GiftDetailsPage extends StatefulWidget {
  const GiftDetailsPage({super.key});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  late String giftId;
  late bool isPublic;
  late bool allowPledge;

  final GiftController controller = GiftController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    giftId = args['giftId'];
    isPublic = args['eventIsPublic'];
    allowPledge = args['allowPledge'];
  }

  // Function to pledge the gift
  void _pledgeGift(Map<String, dynamic> gift) async {
    try {
      // Update the gift status to pledged
      await controller.pledgeGift(gift);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gift successfully pledged!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pledge the gift.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Gift Details',
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: controller.getGiftDetails(isPublic, giftId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Gift not found.'));
          }

          final gift = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  gift['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  gift['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Category:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  gift['category'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Price:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '\$${gift['price']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      gift['status'] ? 'Available' : 'Pledged',
                      style: TextStyle(
                        fontSize: 16,
                        color: gift['status'] ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                // Show pledge button if allowed
                if (allowPledge && gift['status'])
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _pledgeGift(gift),
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
