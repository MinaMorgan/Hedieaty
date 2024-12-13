import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/shared_preferences_manager.dart';
import '/services/image_uploader.dart';
import '/services/firebase_manager.dart';
import '/models/user_model.dart';

class UserController {
  final FirebaseManager firebase = FirebaseManager();
  final SharedPreferencesManager sharedPreferences = SharedPreferencesManager();

  // Register
  Future<bool> register(File? photo, String name, String phoneNumber,
      String email, String password) async {
    try {
      final result = await firebase.authSignUp(email, password);
      final firebaseUser = result.user;

      String photoURL;
      if (photo != null) {
        photoURL = await ImageUploadService().uploadImageToImgur(photo) ??
            'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png';
      } else {
        photoURL =
            'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png';
      }

      if (firebaseUser != null) {
        UserModel user = UserModel(
          id: firebaseUser.uid,
          photoURL: photoURL,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
        );
        await firebase.storeSignUp(firebaseUser.uid, user.toMap());
      }
      return true;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      await firebase.signIn(email, password);
      await _saveUserInSharedPrefernces();

      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> _saveUserInSharedPrefernces() async {
    try {
      String userId = await firebase.currentUser.uid;

      // Fetch user details from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDetails =
          await firebase.getUserDetailsById(userId);

      // Add userId explicitly to the map
      Map<String, dynamic> userData = userDetails.data()!;
      userData['userId'] = userId;

      await sharedPreferences.saveUserDetails(userData);
    } catch (e) {
      print('Saving data to shared preferences error: $e');
    }
  }

  // Get Current User Details
  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDetails(
      String userId) async {
    return await firebase.getUserDetailsById(userId);
  }

  // Get User Details by Email or Phone Number
  Future<QuerySnapshot> getUserDetails(
      bool isAddingByEmail, String input) async {
    if (isAddingByEmail) {
      return await firebase.getUserByEmail(input);
    } else {
      return await firebase.getUserByPhoneNumber(input);
    }
  }

  // Updates the user information in Firestore.
  Future<bool> updateUser(String userId, {String? name, String? phone}) async {
    try {
      // Build update map dynamically
      final Map<String, String> updateData = {};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phoneNumber'] = phone;

      // Update user document in Firestore
      await firebase.updateUser(userId, updateData);

      return true;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  // Log out
  Future<void> logOut() async {
    await sharedPreferences.clearAll();
    await firebase.signOut();
  }
}
