import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/firebase_manager.dart';
import '/services/sharedPreferences_manager.dart';
import '/models/gift_model.dart';

class GiftController {
  final FirebaseManager firebase = FirebaseManager();
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  // Create new Gift
  Future<bool> createGift(String eventId, String name, String description,
      String category, int price) async {
    try {
      String userId = await sharedPreferences.getUserId();
      GiftModel newGift = GiftModel(
          eventId: eventId,
          userId: userId,
          name: name,
          description: description,
          category: category,
          price: price,
          status: true);
      await firebase.addGift(newGift.toMap());
      return true;
    } catch (e) {
      print('Gift Creation error: $e');
      return false;
    }
  }

  Stream<QuerySnapshot> getGiftsByEventId(String eventId) {
    try {
      final eventGifts = firebase.getGiftsByEventId(eventId);
      return eventGifts;
    } catch (e) {
      throw Exception('Error fetching events for event $eventId: $e');
    }
  }

  Future<bool> editGift(
      String giftId, String eventId, String name, String description, String category, int price) async {
    try {
      String userId = await sharedPreferences.getUserId();
      GiftModel updatedGift = GiftModel(
          eventId:eventId, userId: userId, name: name, description: description, category: category, price:price, status: true);
      await firebase.updateGift(giftId, updatedGift.toMap());
      return true;
    } catch (e) {
      print("Failed to update event: $e");
      return false;
    }
  }

  Future<bool> deleteGift(String giftId) async {
    try {
      await firebase.removeGift(giftId);
      return true;
    } catch (e) {
      print("Failed to remove gift: $e");
      return false;
    }
  }
}
