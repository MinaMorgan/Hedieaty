import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';


class GiftsPage extends StatelessWidget {
  final String eventTitle;

  GiftsPage({super.key, required this.eventTitle});

  // Dummy data for gifts associated with each event
  final List<Map<String, String>> gifts = [
    {
      'event': 'My Birthday Celebration',
      'giftName': 'Wireless Headphones',
      'description': 'High-quality noise-cancelling headphones.',
    },
    {
      'event': 'My Birthday Celebration',
      'giftName': 'Smart Watch',
      'description': 'Feature-packed smartwatch with health tracking.',
    },
    {
      'event': 'Graduation Party',
      'giftName': 'Leather Briefcase',
      'description': 'Stylish and durable briefcase for work.',
    },
    {
      'event': 'Graduation Party',
      'giftName': 'Personalized Mug',
      'description': 'A mug with my name engraved.',
    },
    {
      'event': 'Engagement Celebration',
      'giftName': 'Dinner Set',
      'description': 'Elegant dinner set for special occasions.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter gifts that match the event title
    final relatedGifts =
        gifts.where((gift) => gift['event'] == eventTitle).toList();

    return Scaffold(
      appBar: GradientAppBar(title: 'Gifts for $eventTitle', showButton: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: relatedGifts.length,
        itemBuilder: (context, index) {
          final gift = relatedGifts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                gift['giftName']!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(gift['description']!),
            ),
          );
        },
      ),
    );
  }
}
