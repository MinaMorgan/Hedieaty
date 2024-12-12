import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';

class GiftDetailsPage extends StatefulWidget {
  const GiftDetailsPage({super.key});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  late String giftId;
  late Map<String, dynamic> giftData;
  late bool allowPledge;

  late String name;
  late String description;
  late String category;
  late int price;
  late bool status;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    giftId = args['giftId'];
    giftData = args['giftData'];
    allowPledge = args['allowPledge'];

    name = giftData['name'];
    description = giftData['description'];
    category = giftData['category'];
    price = giftData['price'];
    status = giftData['status'];
  }

  void _pledgeGift() async {
    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This gift has already been pledged!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update the gift status to pledged in the database (pseudo-code)
    // await GiftController().updateGiftStatus(widget.giftId, false);

    setState(() {
      status = false;
    });

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gift Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // Gift Description
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Gift Category
            Text(
              'Category:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              category,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Gift Price
            Text(
              'Price:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              '\$$price',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Gift Status
            Text(
              'Status:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              status ? 'Available' : 'Pledged',
              style: TextStyle(
                fontSize: 16,
                color: status ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32.0),

            // Pledge Button
            if (allowPledge && status)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pledgeGift,
                  icon:
                      const Icon(Icons.volunteer_activism, color: Colors.white),
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
      ),
    );
  }
}
