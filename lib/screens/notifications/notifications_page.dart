import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/widgets/gradient_appbar.dart';
import '/widgets/custom_bottom_navigation_bar.dart';
import '/controller/gift_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final GiftController controller = GiftController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Notifications'),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getPledgedGifts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Notifications.'));
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
                    '${giftData['name']} is pledged',
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
                        'Pledged by: ${giftData['pledgedUserName']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Date: ${giftData['dueDate']}',
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
                      'allowPledge': false
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
