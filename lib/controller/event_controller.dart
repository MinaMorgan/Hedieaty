import '/services/shared_preferences_manager.dart';
import '/controller/gift_controller.dart';
import '/models/event_model.dart';

class EventController {
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  final GiftController giftController = GiftController();

  // Create new Event
  Future<Map<String, dynamic>> createEvent(
      String title, String description, String date, bool isPublic) async {
    try {
      String userId = await sharedPreferences.getUserId();
      EventModel newEvent = EventModel(
        userId: userId,
        title: title,
        description: description,
        date: date,
        isPublic: isPublic,
      );

      String id;

      if (isPublic) {
        id = await EventModel.createPublicEvent(newEvent);
      } else {
        id = await EventModel.createPrivateEvent(newEvent);
      }
      return {'id': id, 'success': true};
    } catch (e) {
      throw Exception('Event Creation error: $e');
    }
  }

  // Edit Existing Event
  Future<bool> editEvent(
      Map<String, dynamic> oldEvent,
      String updatedTitle,
      String updatedDescription,
      String updatedDate,
      bool updatedIsPublic) async {
    try {
      String userId = await sharedPreferences.getUserId();
      EventModel updatedEvent = EventModel(
        userId: userId,
        title: updatedTitle,
        description: updatedDescription,
        date: updatedDate,
        isPublic: updatedIsPublic,
      );

      if (oldEvent['isPublic'] == updatedIsPublic) {
        if (updatedEvent.isPublic) {
          await EventModel.updatePublicEvent(oldEvent['id'], updatedEvent);
        } else {
          await EventModel.updatePrivateEvent(oldEvent['id'], updatedEvent);
        }
      } else {
        updateEventVisibility(oldEvent, updatedEvent.toPublicMap());
      }
      return true;
    } catch (e) {
      throw Exception("Failed to update event: $e");
    }
  }

  // Delete Event
  Future<bool> deleteEvent(bool isPublic, String eventId) async {
    try {
      if (isPublic) {
        print(eventId.runtimeType);
        await EventModel.deletePublicEvent(eventId);
      } else {
        await EventModel.deletePrivateEvent(eventId);
      }
      giftController.deleteGiftsByEventId(isPublic, eventId);
      return true;
    } catch (e) {
      throw Exception("Failed to remove event: $e");
    }
  }

  // Fetch Events
  Stream<List<Map<String, dynamic>>> getEventsByUserId(
      String userId, bool showLocal) async* {
    try {
      final List<Map<String, dynamic>> events = [];

      // Fetch Private Events
      if (showLocal) {
        final privateEvents = await EventModel.getPrivateEvents(userId);
        final localEvents = privateEvents.map((event) {
          // Fix the type conversion
          final updatedEvent = Map<String, dynamic>.from(event);
          updatedEvent['id'] = event['id'].toString();
          updatedEvent['isPublic'] = false;

          return updatedEvent;
        }).toList();
        events.addAll(localEvents);
      }

      // Fetch Public Events
      final publicEvents = EventModel.getPublicEvents(userId);
      await for (var snapshot in publicEvents) {
        final firebaseEvents = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        events.addAll(firebaseEvents);
        yield events;
      }
    } catch (e) {
      throw Exception('Error fetching events for user $userId: $e');
    }
  }

  // Change Visibility
  Future<void> updateEventVisibility(
      Map<String, dynamic> oldEvent, Map<String, dynamic> newEvent) async {
    try {
      final event = await createEvent(newEvent['title'],
          newEvent['description'], newEvent['date'], newEvent['isPublic']);

      final giftList = giftController.getGiftsByEventId(
          oldEvent['isPublic'], oldEvent['id']);

      await for (var gifts in giftList) {
        for (var gift in gifts) {
          await giftController.createGift(
            newEvent['isPublic'],
            event['id'],
            gift['name'],
            gift['description'],
            gift['category'],
            gift['price'],
            gift['status'],
            gift['pledgeUserId'],
            gift['pledgeUserName'],
            gift['pledgeDate'],
          );
          print('Gift created: $gift');
        }
        print('here1');
      }
      await deleteEvent(oldEvent['isPublic'], oldEvent['id']);
      print('here111');
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update event visibility: $e');
    }
  }
}
