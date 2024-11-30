import 'package:hedieaty/controller/user_controller.dart';
import '/services/sharedPreferences_manager.dart';
import '/services/firebase_manager.dart';
import '/models/friend_model.dart';

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
}
