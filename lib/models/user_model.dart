// User Model
class UserModel {
  String id;
  String photoURL;
  String name;
  String phoneNumber;
  String email;

  UserModel(
      {required this.id,
      required this.photoURL,
      required this.name,
      required this.phoneNumber,
      required this.email});

  Map<String, String> toMap() {
    return {
      'id': id,
      'photoURL': photoURL,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}
/*
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

 */
