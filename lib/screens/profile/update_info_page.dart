import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

class UpdateInfoPage extends StatefulWidget {
  @override
  _UpdateInfoPageState createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Update Personal Information'),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E88E5)],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save updated information
                String updatedName = nameController.text;
                String updatedEmail = emailController.text;
                // Update the user information
                print('Updated Name: $updatedName');
                print('Updated Email: $updatedEmail');
                Navigator.pop(context); // Return to previous page
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E88E5)),
              child: Text(
                  'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
