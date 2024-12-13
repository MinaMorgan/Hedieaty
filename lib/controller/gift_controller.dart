import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/firebase_manager.dart';
import 'package:intl/intl.dart';
import '/services/shared_preferences_manager.dart';
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
      throw Exception('Error fetching gifts for event $eventId: $e');
    }
  }

  Stream<DocumentSnapshot> getGiftById(String giftId) {
    try {
      final giftDetails = firebase.getGiftById(giftId);
      return giftDetails;
    } catch (e) {
      throw Exception('Error fetching details for gift $giftId: $e');
    }
  }

  Stream<QuerySnapshot> getPledgedGifts(String userId) {
    try {
      final pledgedGifts = firebase.getPLedgedGift(userId);
      print(pledgedGifts);
      return pledgedGifts;
    } catch (e) {
      throw Exception('Error fetching pledged gifts for user $userId: $e');
    }
  }

  Future<bool> editGift(String giftId, String eventId, String name,
      String description, String category, int price) async {
    try {
      String userId = await sharedPreferences.getUserId();
      GiftModel updatedGift = GiftModel(
          eventId: eventId,
          userId: userId,
          name: name,
          description: description,
          category: category,
          price: price,
          status: true);
      await firebase.updateGift(giftId, updatedGift.toMap());
      return true;
    } catch (e) {
      print("Failed to update gift: $e");
      return false;
    }
  }

  Future<bool> pledgeGift(String giftId, String userName) async {
    try {
      DateTime date = DateTime.now();
      String dueDate = DateFormat('yyyy-MM-dd').format(date);
      await firebase.updateGiftStatus(giftId);
      await firebase.addPledgedUserName(giftId, userName);
      await firebase.addPledgedDate(giftId, dueDate);
      return true;
    } catch (e) {
      print("Failed to update gift: $e");
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
