import 'dart:io';
import '/services/shared_preferences_manager.dart';
import '/services/image_uploader.dart';
import '/models/user_model.dart';

class UserController {
  static final SharedPreferencesManager _sharedPreferences =
      SharedPreferencesManager();

  /// Registers a new user and stores their information in Firestore.
  Future<bool> register(File? photo, String name, String phoneNumber,
      String email, String password) async {
    const defaultPhotoURL =
        'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png';

    try {
      final result = await UserModel.signUpAuth(email, password);
      final firebaseUser = result.user;

      if (firebaseUser != null) {
        final photoURL = photo != null
            ? (await ImageUploadService().uploadImageToImgur(photo) ??
                defaultPhotoURL)
            : defaultPhotoURL;

        UserModel user = UserModel(
          id: firebaseUser.uid,
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          photoURL: photoURL,
        );

        await user.signUpStore();
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      print('Sign up error: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Logs in a user and retrieves their data from Firestore.
  Future<bool> login(String email, String password) async {
    try {
      final result = await UserModel.signInAuth(email, password);
      final firebaseUser = result.user;

      if (firebaseUser != null) {
        final snapshot = await UserModel.getUserById(firebaseUser.uid);
        final userData = snapshot.data();

        if (userData == null) throw Exception('User data not found.');

        final user = UserModel(
          id: firebaseUser.uid,
          email: userData['email'],
          name: userData['name'],
          phoneNumber: userData['phoneNumber'],
          photoURL: userData['photoURL'],
        );

        await user.saveUser();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// Logs out the current user.
  Future<void> logOut() async {
    await UserModel.unSaveUser();
    await UserModel.signOut();
  }

  /// Updates the user's profile information in Firestore.
  Future<bool> updateUser(String? name, String? phone) async {
    try {
      final userId = await _sharedPreferences.getUserId();
      final snapshot = await UserModel.getUserById(userId);
      final userData = snapshot.data();

      if (userData == null) throw Exception('User data not found.');

      UserModel user = UserModel(
        id: userId,
        email: userData['email'],
        name: userData['name'],
        phoneNumber: userData['phoneNumber'],
        photoURL: userData['photoURL'],
      );

      if (name != null) user.name = name;
      if (phone != null) user.phoneNumber = phone;

      await user.updateUser();
      await user.saveUser();
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  /// Retrieves a user's ID by email or phone number.
  Future<String?> getUserId(bool isAddingByEmail, String input) async {
    try {
      final snapshot = isAddingByEmail
          ? await UserModel.getUserByEmail(input)
          : await UserModel.getUserByPhoneNumber(input);

      if (snapshot.docs.isEmpty) {
        throw Exception('No user found for input: $input');
      }
      return snapshot.docs.first.id;
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }

  /// Retrieves many users' details.
  Future<List<Map<String, dynamic>>> getUsersDetails(
      List<String> usersIds) async {
    try {
      final usersDetailsSnapshot = await UserModel.getUsersDetails(usersIds);

      final usersList = usersDetailsSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'email': doc.data()['email'],
          'name': doc.data()['name'],
          'phoneNumber': doc.data()['phoneNumber'],
          'photoURL': doc.data()['photoURL'],
        };
      }).toList();

      return usersList;
    } catch (e) {
      print('Error fetching users details: $e');
      return [];
    }
  }
}
