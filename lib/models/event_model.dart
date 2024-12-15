// Event Model
class EventModel {
  String userId;
  String title;
  String description;
  String date;
  bool isPublic;

  EventModel(
      {required this.userId,
      required this.title,
      required this.description,
      required this.date,
      required this.isPublic
      });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'date': date,
      'isPublic': isPublic? true :  0,
    };
  }
}
