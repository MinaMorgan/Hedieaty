import '/globals.dart';

// User Model
class User {
  final String name;
  final String email;
  final String password;

  User({required this.name, required this.email, required this.password});

  // Convert a User into a Map object (for inserting into DB)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Method to insert this User into the database
  Future<int> insert() async {
    return await dbHelper.insertUser(toMap());
  }

  Future<bool> getUser() async {
    return await dbHelper.getUser(email, password);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await dbHelper.getUsers();
  }
}
