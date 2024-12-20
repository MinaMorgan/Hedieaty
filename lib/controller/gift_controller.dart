import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '/services/shared_preferences_manager.dart';
import '/models/gift_model.dart';

class GiftController {
  final SharedPreferencesManager _sharedPreferences =
      SharedPreferencesManager();

  // Create new Gift
  Future<bool> createGift(
      bool isPublic,
      String eventId,
      String name,
      String description,
      String category,
      int price,
      bool status,
      String? pledgeUserId,
      String? pledgeUserName,
      String? pledgeDate) async {
    try {
      String userId = await _sharedPreferences.getUserId();
      GiftModel newGift = GiftModel(
        eventId: eventId,
        userId: userId,
        name: name,
        description: description,
        category: category,
        price: price,
        status: status,
        pledgeUserId: pledgeUserId,
        pledgeUserName: pledgeUserName,
        pledgeDate: pledgeDate,
      );

      if (isPublic) {
        await GiftModel.createPublicGift(newGift);
      } else {
        await GiftModel.createPrivateGift(newGift);
      }
      return true;
    } catch (e) {
      throw ('Gift Creation error: $e');
    }
  }

  // Edit Existing Gift
  Future<bool> editGift(
      bool isPublic,
      String giftId,
      String eventId,
      String name,
      String description,
      String category,
      int price,
      bool status) async {
    try {
      String userId = await _sharedPreferences.getUserId();
      GiftModel updatedGift = GiftModel(
        eventId: eventId,
        userId: userId,
        name: name,
        description: description,
        category: category,
        price: price,
        status: status,
      );

      if (isPublic) {
        await GiftModel.updatePublicGift(giftId, updatedGift);
      } else {
        await GiftModel.updatePrivateGift(giftId, updatedGift);
      }
      return true;
    } catch (e) {
      throw ("Failed to update gift: $e");
    }
  }

  // Delete Gift
  Future<bool> deleteGift(bool isPublic, String giftId) async {
    try {
      if (isPublic) {
        await GiftModel.deletePublicGift(giftId);
      } else {
        await GiftModel.deletePrivateGift(giftId);
      }
      return true;
    } catch (e) {
      throw ("Failed to remove gift: $e");
    }
  }

  // Delete Gift on Deleting Parent Event
  Future<bool> deleteGiftsByEventId(bool isPublic, String eventId) async {
    try {
      if (isPublic) {
        final firebaseGifts = GiftModel.getPublicGiftsByEventId(eventId);
        await for (var snapshot in firebaseGifts) {
          for (var doc in snapshot.docs) {
            await GiftModel.deletePublicGift(doc.id);
          }
        }
      } else {
        await GiftModel.deletePrivateGiftsByEventId(eventId.toString());
      }
      return true;
    } catch (e) {
      throw ("Failed to remove gift: $e");
    }
  }

  // Fetch Gifts
  Stream<List<Map<String, dynamic>>> getGiftsByEventId(
      bool isPublic, String eventId) async* {
    try {
      if (isPublic) {
        final gifts = GiftModel.getPublicGiftsByEventId(eventId);
        await for (var snapshot in gifts) {
          final gifts = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
          yield gifts;
        }
      } else {
        final privateGifts = await GiftModel.getPrivateGiftsByEventId(eventId);
        final gifts = privateGifts.map((gift) {
          // Handle the type conversion
          final updatedGift = Map<String, dynamic>.from(gift);
          updatedGift['id'] = gift['id'].toString();
          if (updatedGift['status'] == 0) {
            updatedGift['status'] = false;
          } else {
            updatedGift['status'] = true;
          }

          return updatedGift;
        }).toList();
        yield gifts;
      }
    } catch (e) {
      throw Exception('Error fetching gifts for event $eventId: $e');
    }
  }

  // Get Gift Details
  Stream<Map<String, dynamic>> getGiftDetails(
      bool isPublic, String giftId) async* {
    try {
      Map<String, dynamic>? giftDetails;

      if (isPublic) {
        final gift = GiftModel.getPublicGift(giftId);
        await for (final snapshot in gift) {
          giftDetails = snapshot.data() as Map<String, dynamic>;
          giftDetails['id'] = snapshot.id;
          break;
        }
      } else {
        final gift = await GiftModel.getPrivateGift(giftId);

        // Handle the type conversion
        giftDetails = Map<String, dynamic>.from(gift);
        giftDetails['id'] = giftId;
        if (giftDetails['status'] == 0) {
          giftDetails['status'] = false;
        } else {
          giftDetails['status'] = true;
        }
      }
      yield giftDetails!;
    } catch (e) {
      throw Exception('Error fetching details for gift $giftId: $e');
    }
  }

  // Get Pledged Gifts
  Stream<QuerySnapshot<Map<String, dynamic>>> getPledgedGifts() async* {
    try {
      String userId = await _sharedPreferences.getUserId();
      final pledgedGifts = GiftModel.getPledgedGifts(userId);
      yield* pledgedGifts;
    } catch (e) {
      throw Exception('Error fetching pledged gifts for user: $e');
    }
  }

  // Get My Pledged Gifts
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyPledgedGifts() async* {
    try {
      String userId = await _sharedPreferences.getUserId();
      final pledgedGifts = GiftModel.getMyPledgedGifts(userId);
      yield* pledgedGifts;
    } catch (e) {
      throw Exception('Error fetching pledged gifts for user: $e');
    }
  }

  // Pledge Gift
  Future<bool> pledgeGift(Map<String, dynamic> gift) async {
    try {
      DateTime date = DateTime.now();
      String pledgedDate = DateFormat('yyyy-MM-dd').format(date);

      String userId = await _sharedPreferences.getUserId();
      String userName = await _sharedPreferences.getName();

      GiftModel pledgedGift = GiftModel(
        eventId: gift['eventId'],
        userId: gift['userId'],
        name: gift['name'],
        description: gift['description'],
        category: gift['category'],
        price: gift['price'],
        status: false,
        pledgeUserId: userId,
        pledgeUserName: userName,
        pledgeDate: pledgedDate,
      );

      await GiftModel.updatePublicGift(gift['id'], pledgedGift);
      return true;
    } catch (e) {
      throw ("Failed to Pledge gift: $e");
    }
  }

  List<Map<String, dynamic>> filterAndSortGifts(
      List<Map<String, dynamic>> gifts, String sortOption, String filter) {
    // Filter by Category
    if (filter != 'All') {
      gifts = gifts.where((gift) => gift['category'] == filter).toList();
    }

    // Sort by selected option
    if (sortOption == 'Name') {
      gifts.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (sortOption == 'Price') {
      gifts.sort((a, b) => a['price'].compareTo(b['price']));
    }

    return gifts;
  }
}
