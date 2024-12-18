import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/firebase_manager.dart';
import '/services/local_database_manager.dart';

class GiftModel {
  String eventId;
  String userId;
  String name;
  String description;
  String category;
  int price;
  bool status;
  String? pledgeUserId;
  String? pledgeUserName;
  String? pledgeDate;

  static FirebaseManager firebase = FirebaseManager();
  static LocalDatabaseManager localDb = LocalDatabaseManager();

  GiftModel(
      {required this.eventId,
      required this.userId,
      required this.name,
      required this.description,
      required this.category,
      required this.price,
      required this.status,
      this.pledgeUserId,
      this.pledgeUserName,
      this.pledgeDate});

  Map<String, dynamic> toPublicMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'pledgeUserId': pledgeUserId,
      'pledgeUserName': pledgeUserName,
      'pledgeDate': pledgeDate
    };
  }

  Map<String, dynamic> toPrivateMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status ? 1 : 0,
      'pledgeUserId': pledgeUserId,
      'pledgeUserName': pledgeUserName,
      'pledgeDate': pledgeDate
    };
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // FireStore Functions
  static Future<void> createPublicGift(GiftModel gift) async {
    await firebase.addGift(gift.toPublicMap());
  }

  static Future<void> updatePublicGift(String id, GiftModel gift) async {
    await firebase.updateGift(id, gift.toPublicMap());
  }

  static Future<void> deletePublicGift(String id) async {
    await firebase.removeGift(id);
  }

  static Stream<DocumentSnapshot> getPublicGift(String id) {
    return firebase.getGift(id);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPublicGiftsByEventId(String eventId) {
    return firebase.getGiftsByEventId(eventId);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPledgedGifts(String userId) {
    return firebase.getPLedgedGifts(userId);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Local Database Functions
  static Future<void> createPrivateGift(GiftModel gift) async {
    await localDb.addGift(gift.toPrivateMap()).toString();
  }

  static Future<void> updatePrivateGift(String id, GiftModel gift) async {
    await localDb.updateGift(int.parse(id), gift.toPrivateMap());
  }

  static Future<void> deletePrivateGift(String id) async {
    await localDb.removeGift(int.parse(id));
  }

  static Future<void> deletePrivateGiftsByEventId(String eventId) async {
    await localDb.removeGiftByEventId(eventId);
  }

  static Future<Map<String, dynamic>> getPrivateGift(String id) {
    return localDb.getGift(int.parse(id));
  }

  static Future<List<Map<String, dynamic>>> getPrivateGiftsByEventId(String eventId) {
    return localDb.getGiftsByEventId(eventId);
  }
}
