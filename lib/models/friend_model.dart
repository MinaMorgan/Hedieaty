import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/firebase_manager.dart';

class FriendModel {
  String userId;
  String friendId;

  static final FirebaseManager _firebase = FirebaseManager();

  FriendModel({required this.userId, required this.friendId});

  Map<String, String> toMap() {
    return {
      'userId': userId,
      'friendId': friendId,
    };
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Add friend
  Future<void> addFriend() async {
    await _firebase.addFriend(toMap());
  }

  // Get Friends Ids
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsIds(
      String userId) {
    return _firebase.getFriendsIds(userId);
  }
}
