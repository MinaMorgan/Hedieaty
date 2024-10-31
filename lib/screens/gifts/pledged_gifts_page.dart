import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';


class PledgedGiftsPage extends StatefulWidget {
  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  // List of pledged gifts with initial dummy data
  List<Map<String, String>> pledgedGifts = [
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

  // Function to handle editing a gift
  void _editGift(int index) {
    setState(() {
      // For demonstration, we'll toggle the status of the gift
      pledgedGifts[index]['status'] =
      pledgedGifts[index]['status'] == 'Pending' ? 'Completed' : 'Pending';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated ${pledgedGifts[index]['giftName']} status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Pledged Gifts'),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E88E5)],
        ),
      ),
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
              trailing: gift['status'] == 'Pending'
                  ? IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editGift(index),
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
