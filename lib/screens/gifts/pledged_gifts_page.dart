import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';


class PledgedGiftsPage extends StatelessWidget {
  const PledgedGiftsPage({super.key});
  // List of pledged gifts with initial dummy data
  static const List<Map<String, String>> pledgedGifts = [
    {
      'giftName': 'Photo Album',
      'friendName': 'Alice Johnson',
      'dueDate': '2024-11-15',
      'status': 'Completed',
    },
    {
      'giftName': 'Book Collection',
      'friendName': 'John Doe',
      'dueDate': '2024-10-28',
      'status': 'Completed',
    },
    {
      'giftName': 'Customized Mug',
      'friendName': 'Emma Watson',
      'dueDate': '2024-12-05',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Pledged Gifts'),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                gift['giftName']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Friend: ${gift['friendName']}'),
                  Text('Due Date: ${gift['dueDate']}'),
                  Text(
                    'Status: ${gift['status']}',
                    style: TextStyle(
                      color: gift['status'] == 'Pending' ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
