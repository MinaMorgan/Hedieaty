import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/gift_controller.dart';
import 'add_gift_page.dart';

class GiftsPage extends StatefulWidget {
  const GiftsPage({super.key});

  @override
  _GiftsPageState createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  late String eventId;
  late String eventTitle;
  late bool eventIsPublic;
  late bool showFull;

  final GiftController _controller = GiftController();

  // Sorting and Filtering Variables
  String _selectedSortOption = 'Name';
  String _selectedCategory = 'All';
  final List<String> sortOptions = ['Name', 'Price'];
  final List<String> categories = [
    'All',
    'Electronics',
    'Toys',
    'Books',
    'Fashion',
    'Home & Living',
    'Health & Beauty',
    'other'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    eventId = args['eventId'];
    eventTitle = args['eventTitle'];
    eventIsPublic = args['eventIsPublic'];
    showFull = args['showFull'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Gifts for $eventTitle',
        showButton: showFull,
        onButtonPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return AddGiftPage(
                  eventId: eventId,
                  isPublic: eventIsPublic,
                );
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
      ),
      body: Column(
        children: [
          // Sorting and Filtering UI
          Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sorting Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sort By:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSortOption,
                            icon: const Icon(Icons.sort,
                                color: Colors.blueAccent),
                            isExpanded: true,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSortOption = newValue!;
                              });
                            },
                            items: sortOptions.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Filtering Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filter by Category:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            icon: const Icon(Icons.filter_list,
                                color: Colors.blueAccent),
                            isExpanded: true,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Gifts List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _controller.getGiftsByEventId(eventIsPublic, eventId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No gifts found.'));
                }

                // Apply sorting and filtering
                final gifts = _controller.filterAndSortGifts(
                    snapshot.data!, _selectedSortOption, _selectedCategory);

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    final gift = gifts[index];

                    Color textColor =
                        gift['status'] ? Colors.green : Colors.red;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          gift['name'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                        subtitle: Text(gift['description']),
                        trailing: (showFull && gift['status'])
                            ? IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editGift(gift),
                              )
                            : null,
                        onTap: () {
                          Navigator.pushNamed(context, '/giftDetails',
                              arguments: {
                                'giftId': gift['id'],
                                'eventIsPublic': eventIsPublic,
                                'allowPledge': !showFull
                              });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editGift(Map<String, dynamic> gift) async {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: gift['name']);
        final descriptionController =
            TextEditingController(text: gift['description']);
        final categoryController =
            TextEditingController(text: gift['category']);
        final priceController =
            TextEditingController(text: gift['price'].toString());

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

                if (await _controller.editGift(
                    eventIsPublic,
                    gift['id'],
                    gift['eventId'],
                    name,
                    description,
                    category,
                    price,
                    gift['status'])) {
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
                if (await _controller.deleteGift(eventIsPublic, gift['id'])) {
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
