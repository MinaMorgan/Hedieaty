import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/sharedPreferences_manager.dart';
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
      UserCredential result = await firebase.authSignUp(email, password);
      User? firebaseUser = result.user;

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
      String userId = firebase.currentUser.uid;
      await sharedPreferences.saveUserId(userId);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Get current user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDetails() async {
    String userId = firebase.currentUser.uid;
    return await firebase.getUserDetails(userId);
  }

  // Get user details
  Future<QuerySnapshot<Map<String, dynamic>>> getUserDetails(
      bool isAddingByEmail, String input) async {
      if (isAddingByEmail) {
        return await firebase.getUserByEmail(input);
      } else {
        return await firebase.getUserByPhoneNumber(input);
      }
  }

  // Log out
  Future<void> logOut() async {
    await sharedPreferences.clearAll();
    await firebase.signOut();
  }
}
