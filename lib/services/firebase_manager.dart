import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '/services/image_uploader.dart';
import '/models/user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //////////////////////////////////////////// Users ////////////////////////////////////////////
  // Sign up
  Future<UserModel?> signUp(File? photo, String name, String phoneNumber,
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;
      String? photoURL;
      if (photo != null) {
        photoURL = await ImageUploadService().uploadImageToImgur(photo);
      }

      if (firebaseUser != null) {
        UserModel user = UserModel(
          id: firebaseUser.uid,
          photoURL: photoURL,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
        );
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(user.toMap());
        return user;
      }
    } catch (e) {
      print('Sign up error: $e');
    }
    return null;
  }

  // Login
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;
      if (firebaseUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
