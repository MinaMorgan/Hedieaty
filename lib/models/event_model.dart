import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/firebase_manager.dart';
import '/services/local_database_manager.dart';

class EventModel {
  String userId;
  String title;
  String description;
  String date;
  bool isPublic;

  static final FirebaseManager _firebase = FirebaseManager();
  static final LocalDatabaseManager _localDb = LocalDatabaseManager();

  EventModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.isPublic,
  });

  Map<String, dynamic> toPublicMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'date': date,
      'isPublic': isPublic,
    };
  }

  Map<String, dynamic> toPrivateMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'date': date,
      'isPublic': isPublic ? 1 : 0,
    };
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // FireStore Functions
  static Future<String> createPublicEvent(EventModel event) async {
    return await _firebase.addEvent(event.toPublicMap());
  }

  static Future<void> updatePublicEvent(String id, EventModel event) async {
    await _firebase.updateEvent(id, event.toPublicMap());
  }

  static Future<void> deletePublicEvent(String id) async {
    await _firebase.removeEvent(id);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPublicEvents(
      String id) {
    return _firebase.getEvents(id);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Local Database Functions
  static Future<String> createPrivateEvent(EventModel event) async {
    final id = await _localDb.addEvent(event.toPrivateMap());
    return id.toString();
  }

  static Future<void> updatePrivateEvent(String id, EventModel event) async {
    await _localDb.updateEvent(int.parse(id), event.toPrivateMap());
  }

  static Future<void> deletePrivateEvent(String id) async {
    await _localDb.removeEvent(int.parse(id));
  }

  static Future<List<Map<String, dynamic>>> getPrivateEvents(String id) {
    return _localDb.getEvents(id);
  }
}
