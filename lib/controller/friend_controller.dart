import '/services/shared_preferences_manager.dart';
import '/models/friend_model.dart';
import '/controller/user_controller.dart';

class FriendController {
  final SharedPreferencesManager _sharedPreferences =
      SharedPreferencesManager();
  final UserController _userController = UserController();

  /// Adds a friend by email or phone number.
  Future<bool> addFriend(bool isAddingByEmail, String input) async {
    try {
      String currentUserId = await _sharedPreferences.getUserId();

      final friendId = await _userController.getUserId(isAddingByEmail, input);

      if (friendId != null && friendId != currentUserId) {
        FriendModel friend = FriendModel(
          userId: currentUserId,
          friendId: friendId,
        );
        await friend.addFriend();
        return true;
      }

      print('Friend ID not found.');
      return false;
    } catch (e) {
      print('Error adding friend: $e');
      return false;
    }
  }

  /// Streams the list of friends with their details.
  Stream<List<Map<String, dynamic>>> showFriends() async* {
    try {
      String userId = await _sharedPreferences.getUserId();

      final friendsStream = FriendModel.getFriendsIds(userId);

      await for (final friendSnapshot in friendsStream) {
        List<String> friendIds =
            friendSnapshot.docs.map((doc) => doc.id).toList();

        if (friendIds.isNotEmpty) {
          final friendsList = await _userController.getUsersDetails(friendIds);
          yield friendsList;
        } else {
          yield []; // Emit an empty list if no friends are found.
        }
      }
    } catch (e) {
      print('Error loading friends: $e');
      yield []; // Emit an empty list on error.
    }
  }

  /// Filters the list of friends based on a search query.
  List<Map<String, dynamic>> filterFriends(
      List<Map<String, dynamic>> friends, String query) {
    return friends
        .where((friend) =>
            friend['name'] != null &&
            friend['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }
}
