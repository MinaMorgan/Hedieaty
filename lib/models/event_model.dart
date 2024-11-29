// User Model
class EventModel {
  String userId;
  String title;
  String description;
  String date;

  EventModel(
      {required this.userId,
      required this.title,
      required this.description,
      required this.date});

  Map<String, String> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'date': date,
    };
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
