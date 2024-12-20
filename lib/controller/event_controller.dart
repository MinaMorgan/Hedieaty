import 'package:intl/intl.dart';
import '/services/shared_preferences_manager.dart';
import '/controller/gift_controller.dart';
import '/models/event_model.dart';

class EventController {
  final SharedPreferencesManager _sharedPreferences =
      SharedPreferencesManager();
  final GiftController _giftController = GiftController();

  // Create new Event
  Future<Map<String, dynamic>> createEvent(
      String title, String description, String date, bool isPublic) async {
    try {
      String userId = await _sharedPreferences.getUserId();
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
      String userId = await _sharedPreferences.getUserId();
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
      print("Failed to update event: $e");
      return false;
    }
  }

  // Delete Event
  Future<bool> deleteEvent(bool isPublic, String eventId) async {
    try {
      if (isPublic) {
        await EventModel.deletePublicEvent(eventId);
      } else {
        await EventModel.deletePrivateEvent(eventId);
      }
      _giftController.deleteGiftsByEventId(isPublic, eventId);
      return true;
    } catch (e) {
      print("Failed to remove event: $e");
      return false;
    }
  }

  // Fetch Events
  Stream<List<Map<String, dynamic>>> getEventsByUserId(
      String userId, bool showLocal) async* {
    try {
      final List<Map<String, dynamic>> events = [];

      // Fetch Public Events
      if (showLocal) {
        final privateEvents = await EventModel.getPrivateEvents(userId);
        final localEvents = privateEvents.map((event) {
          // Fix type conversion
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

  //TODO:
  // Change Visibility
  Future<void> updateEventVisibility(
      Map<String, dynamic> oldEvent, Map<String, dynamic> newEvent) async {
    try {
      // Create the new event
      final event = await createEvent(
        newEvent['title'],
        newEvent['description'],
        newEvent['date'],
        newEvent['isPublic'],
      );

      if (!(event['success'] ?? false)) {
        throw Exception('Failed to create the new event.');
      }

      // Migrate gifts to the new event
      final gifts = await _giftController
          .getGiftsByEventId(oldEvent['isPublic'], oldEvent['id'])
          .first;

      for (var gift in gifts) {
        await _giftController.createGift(
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
      }

      // Delete the old event
      await deleteEvent(oldEvent['isPublic'], oldEvent['id']);
    } catch (e) {
      print('Failed to update event visibility: $e');
    }
  }

  List<Map<String, dynamic>> filterAndSortEvents(
      List<Map<String, dynamic>> events, String sortOption, String filter) {
    final now = DateTime.now();

    // Filter by event date
    if (filter != 'All') {
      events = events.where((event) {
        final eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);
        switch (filter) {
          case 'Upcoming':
            return eventDate.isAfter(now);
          case 'Current':
            return eventDate.year == now.year &&
                eventDate.month == now.month &&
                eventDate.day == now.day;
          case 'Past':
            return eventDate.isBefore(DateTime(now.year, now.month, now.day));
          default:
            return true;
        }
      }).toList();
    }

    // Sort by selected option
    switch (sortOption) {
      case 'Title':
        events.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      case 'Date':
        events.sort((a, b) => DateFormat('yyyy-MM-dd')
            .parse(a['date'])
            .compareTo(DateFormat('yyyy-MM-dd').parse(b['date'])));
        break;
      default:
        break;
    }

    return events;
  }
}
