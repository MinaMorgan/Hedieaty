// Event Model
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
}
