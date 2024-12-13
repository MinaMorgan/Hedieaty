import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/shared_preferences_manager.dart';
import '/services/firebase_manager.dart';
import '/models/event_model.dart';

class EventController {
  final FirebaseManager firebase = FirebaseManager();
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  // Create new Event
  Future<bool> createEvent(
      String title, String description, String date) async {
    try {
      String userId = await sharedPreferences.getUserId();
      EventModel newEvent = EventModel(
          userId: userId, title: title, description: description, date: date);
      await firebase.addEvent(newEvent.toMap());
      return true;
    } catch (e) {
      print('Event Creation error: $e');
      return false;
    }
  }

  Stream<QuerySnapshot> getEventsByUserId(String userId) {
    try {
      final userEvents = firebase.getEvents(userId);
      return userEvents;
    } catch (e) {
      throw Exception('Error fetching events for user $userId: $e');
    }
  }

  // Edit Existing Event
  Future<bool> editEvent(
      String eventId, String title, String description, String date) async {
    try {
      String userId = await sharedPreferences.getUserId();
      EventModel updatedEvent = EventModel(
          userId: userId, title: title, description: description, date: date);
      await firebase.updateEvent(eventId, updatedEvent.toMap());
      return true;
    } catch (e) {
      print("Failed to update event: $e");
      return false;
    }
  }

  // Delete Event
  Future<bool> deleteEvent(String eventId) async {
    try {
      await firebase.removeEvent(eventId);
      return true;
    } catch (e) {
      print("Failed to remove event: $e");
      return false;
    }
  }
}
