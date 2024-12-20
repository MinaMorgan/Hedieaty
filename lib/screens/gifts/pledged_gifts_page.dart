import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/gift_controller.dart';

class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  final GiftController controller = GiftController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'My Pledged Gifts'),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getMyPledgedGifts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pledged gifts found.'));
          }

          final pledgedGifts = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: pledgedGifts.length,
            itemBuilder: (context, index) {
              final giftData =
                  pledgedGifts[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.card_giftcard,
                    color: Theme.of(context).primaryColor,
                    size: 36,
                  ),
                  title: Text(
                    giftData['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(
                        giftData['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Owner: ${giftData['pledgeUserName']}', //todo: Should appear owner name
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Pledge Date: ${giftData['pledgeDate']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/giftDetails', arguments: {
                      'giftId': pledgedGifts[index].id,
                      'eventIsPublic': true,
                      'allowPledge': false
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
}
