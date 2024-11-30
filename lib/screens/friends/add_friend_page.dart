import 'package:flutter/material.dart';
import '/widgets/gradient_appbar.dart';
import '/controller/friend_controller.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _inputController = TextEditingController();
  bool isAddingByEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Add Friend'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleInputType(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAddingByEmail
                        ? const Color(0xFF1E88E5)
                        : Colors.grey[300],
                  ),
                  child: const Text('By Email',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => _toggleInputType(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isAddingByEmail
                        ? const Color(0xFF1E88E5)
                        : Colors.grey[300],
                  ),
                  child: const Text('By Phone',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText:
                    isAddingByEmail ? 'Enter Email' : 'Enter Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: isAddingByEmail
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final input = _inputController.text.trim();
                if (_isValidInput(input)) {
                  if (await addFriend(input)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Friend added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add friend.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isAddingByEmail
                            ? 'Please enter a valid email.'
                            : 'Please enter a valid phone number.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Add Friend',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleInputType(bool byEmail) {
    setState(() {
      isAddingByEmail = byEmail;
      _inputController.clear();
    });
  }

  bool _isValidInput(String input) {
    if (isAddingByEmail) {
      return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(input);
    } else {
      return RegExp(r"^\d{10,15}$").hasMatch(input);
    }
  }

  // Adding Friend by Email or Phone Number
  Future<bool> addFriend(String input) async {
    final FriendController controller = FriendController();
    return await controller.addFriend(isAddingByEmail, input);
  }
}
