import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/firebase_manager.dart';
import '/services/local_database_manager.dart';

class EventModel {
  String userId;
  String title;
  String description;
  String date;
  bool isPublic;

  static FirebaseManager firebase = FirebaseManager();
  static LocalDatabaseManager localDb = LocalDatabaseManager();

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
    return await firebase.addEvent(event.toPublicMap());
  }

  static Future<void> updatePublicEvent(String id, EventModel event) async {
    await firebase.updateEvent(id, event.toPublicMap());
  }

  static Future<void> deletePublicEvent(String id) async {
    await firebase.removeEvent(id);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPublicEvents(
      String id) {
    return firebase.getEvents(id);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Local Database Functions
  static Future<String> createPrivateEvent(EventModel event) async {
    final id =  await localDb.addEvent(event.toPrivateMap());
    return id.toString();
  }

  static Future<void> updatePrivateEvent(String id, EventModel event) async {
    await localDb.updateEvent(int.parse(id), event.toPrivateMap());
  }

  static Future<void> deletePrivateEvent(String id) async {
    await localDb.removeEvent(int.parse(id));
  }

  static Future<List<Map<String, dynamic>>> getPrivateEvents(String id) {
    return localDb.getEvents(id);
  }
}
