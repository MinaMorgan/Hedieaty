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

  static final FirebaseManager _firebase = FirebaseManager();
  static final LocalDatabaseManager _localDb = LocalDatabaseManager();

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
    await _firebase.addGift(gift.toPublicMap());
  }

  static Future<void> updatePublicGift(String id, GiftModel gift) async {
    await _firebase.updateGift(id, gift.toPublicMap());
  }

  static Future<void> deletePublicGift(String id) async {
    await _firebase.removeGift(id);
  }

  static Stream<DocumentSnapshot> getPublicGift(String id) {
    return _firebase.getGift(id);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPublicGiftsByEventId(
      String eventId) {
    return _firebase.getGiftsByEventId(eventId);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPledgedGifts(
      String userId) {
    return _firebase.getPLedgedGifts(userId);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyPledgedGifts(
      String userId) {
    return _firebase.getMyPLedgedGifts(userId);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Local Database Functions
  static Future<void> createPrivateGift(GiftModel gift) async {
    await _localDb.addGift(gift.toPrivateMap());
  }

  static Future<void> updatePrivateGift(String id, GiftModel gift) async {
    await _localDb.updateGift(int.parse(id), gift.toPrivateMap());
  }

  static Future<void> deletePrivateGift(String id) async {
    await _localDb.removeGift(int.parse(id));
  }

  static Future<void> deletePrivateGiftsByEventId(String eventId) async {
    await _localDb.removeGiftByEventId(eventId);
  }

  static Future<Map<String, dynamic>> getPrivateGift(String id) {
    return _localDb.getGift(int.parse(id));
  }

  static Future<List<Map<String, dynamic>>> getPrivateGiftsByEventId(
      String eventId) {
    return _localDb.getGiftsByEventId(eventId);
  }
}
