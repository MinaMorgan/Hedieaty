import '/services/sharedPreferences_manager.dart';
import '/services/firebase_manager.dart';
import '/models/user_model.dart';
import '/models/friend_model.dart';
import '/controller/user_controller.dart';

class FriendController {
  final FirebaseManager firebase = FirebaseManager();
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();
  final UserController userController = UserController();

  // Add Friend
  Future<bool> addFriend(bool isAddingByEmail, String input) async {
    try {
      final friend =
          await userController.getUserDetails(isAddingByEmail, input);
      if (friend.docs.isNotEmpty) {
        String currentUserId = await sharedPreferences.getUserId();

        FriendModel friends = FriendModel(
          userId: currentUserId,
          friendId: friend.docs.first.id,
        );
        await firebase.addFriend(friends.toMap());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error adding friend: $e');
      return false;
    }
  }

  // Show Friends
  Stream<List<Map<String, dynamic>>> showFriends() async* {
    try {
      String userId = await sharedPreferences.getUserId();
      final friendsStream = firebase.getFriendsIds(userId);

      await for (final friendSnapshot in friendsStream) {
        List<String> friendIds =
            friendSnapshot.docs.map((doc) => doc.id).toList();

        if (friendIds.isNotEmpty) {
          final friendsDetailsSnapshot =
              await firebase.getFriendsDetails(friendIds);

          final friendsList = friendsDetailsSnapshot.docs.map((doc) {
            UserModel user = UserModel(
              id: doc.id,
              photoURL: doc['photoURL'] ??
                  'default_photo_url', // Use a default if null
              name: doc['name'],
              phoneNumber: doc['phoneNumber'],
              email: doc['email'],
            );
            return user.toMap();
          }).toList();

          yield friendsList;
        } else {
          yield []; // Yield an empty list if no friends
        }
      }
    } catch (e) {
      print('Error in loading friends: $e');
      yield []; // Yield an empty list in case of error
    }
  }

  List<Map<String, dynamic>> filterFriends(
      List<Map<String, dynamic>> friends, String query) {
    return friends
        .where((friend) => friend['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }
}
