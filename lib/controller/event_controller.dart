import '/services/local_database_manager.dart';
import '/services/shared_preferences_manager.dart';
import '/services/firebase_manager.dart';
import '/models/event_model.dart';

class EventController {
  final FirebaseManager firebase = FirebaseManager();
  final LocalDatabaseManager localDb = LocalDatabaseManager();
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  // Create new Event
  Future<bool> createEvent(Map event) async {
    try {
      String userId = await sharedPreferences.getUserId();

      EventModel newEvent = EventModel(
          userId: userId,
          title: event['title'],
          description: event['description'],
          date: event['date'],
          isPublic: event['isPublic'] == true);

      if (newEvent.isPublic) {
        await firebase.addEvent(newEvent.toMap());
      } else {
        await localDb.insertEvent(newEvent.toMap());
      }
      return true;
    } catch (e) {
      throw Exception('Event Creation error: $e');
    }
  }

  // Fetch Events by User ID
  Stream<List<Map<String, dynamic>>> getEventsByUserId(
      String userId, bool showLocal) async* {
    try {
      final firebaseEvents = firebase.getEvents(userId);
      await for (var snapshot in firebaseEvents) {
        final firebaseEvents = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        final List<Map<String, dynamic>> events = [];
        events.clear();
        events.addAll(firebaseEvents);

        if (showLocal) {
          final localEvents = await localDb.getEvents(userId);
          events.addAll(localEvents);
        }
        yield events;
      }
    } catch (e) {
      throw Exception('Error fetching events for user $userId: $e');
    }
  }

  // Edit Existing Event
  Future<bool> editEvent(Map<String, dynamic> event, String title,
      String description, String date, bool isPublicNew) async {
    try {
      String userId = await sharedPreferences.getUserId();
      bool isPublicOld = (event['isPublic'] == true);

      EventModel updatedEvent = EventModel(
          userId: userId,
          title: title,
          description: description,
          date: date,
          isPublic: isPublicNew);

      if (isPublicOld == isPublicNew) {
        if (updatedEvent.isPublic) {
          await firebase.updateEvent(event['id'], updatedEvent.toMap());
        } else {
          await localDb.updateEvent(event['id'], updatedEvent.toMap());
        }
      } else {
        deleteEvent(event);
        createEvent(updatedEvent.toMap());
      }
      return true;
    } catch (e) {
      throw Exception("Failed to update event: $e");
    }
  }

  // Delete Event
  Future<bool> deleteEvent(Map<String, dynamic> event) async {
    try {
      bool isPublic = (event['isPublic'] == true);

      if (isPublic) {
        await firebase.removeEvent(event['id']);
      } else {
        await localDb.removeEvent(event['id']);
      }
      return true;
    } catch (e) {
      throw Exception("Failed to remove event: $e");
    }
  }
}
