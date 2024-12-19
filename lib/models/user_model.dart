import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/firebase_manager.dart';
import '/services/shared_preferences_manager.dart';

class UserModel {
  String id;
  String email;
  String name;
  String phoneNumber;
  String photoURL;

  static final FirebaseManager _firebase = FirebaseManager();
  static final SharedPreferencesManager _sharedPreferences =
      SharedPreferencesManager();

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.photoURL,
  });

  Map<String, String> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
    };
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Sign Up Functions
  static Future<UserCredential> signUpAuth(
      String email, String password) async {
    return await _firebase.authSignUp(email, password);
  }

  Future<void> signUpStore() async {
    return await _firebase.storeSignUp(id, toMap());
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Sign In Functions
  static Future<UserCredential> signInAuth(
      String email, String password) async {
    return await _firebase.signIn(email, password);
  }

  Future<void> saveUser() async {
    await _sharedPreferences.saveUserDetails(id, toMap());
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Sign Out Functions
  static Future<void> signOut() async {
    await _firebase.signOut();
  }

  static Future<void> unSaveUser() async {
    await _sharedPreferences.clearAll();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Get User Details functions
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(
      String id) async {
    return await _firebase.getUserById(id);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(
      String email) async {
    return await _firebase.getUserByEmail(email);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserByPhoneNumber(
      String phoneNumber) async {
    return await _firebase.getUserByPhoneNumber(phoneNumber);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUsersDetails(
      List<String> usersIds) async {
    return await _firebase.getUsersDetails(usersIds);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Update User
  Future<void> updateUser() async {
    await _firebase.updateUser(id, toMap());
  }
}
