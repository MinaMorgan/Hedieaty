// User Model
class UserModel {
  final String id;
  final String? photoURL;
  final String name;
  final String phoneNumber;
  final String email;

  UserModel(
      {required this.id,
      this.photoURL =
          'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png',
      required this.name,
      required this.phoneNumber,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoURL': photoURL,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      photoURL: map['photoURL'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
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
}
