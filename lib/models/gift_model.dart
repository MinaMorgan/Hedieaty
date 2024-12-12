// Gift Model
class GiftModel {
  String eventId;
  String userId;
  String name;
  String description;
  String category;
  int price;
  bool status;

  GiftModel(
      {required this.eventId,
      required this.userId,
      required this.name,
      required this.description,
      required this.category,
      required this.price,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
    };
  }
}
