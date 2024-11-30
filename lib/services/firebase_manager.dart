import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //////////////////////////////////////////// Users ////////////////////////////////////////////
  // Sign up Authentication
  Future<UserCredential> authSignUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign up Store
  Future<void> storeSignUp(String id, Map<String, String> user) async {
    await _firestore.collection('users').doc(id).set(user);
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Get Current User
  get currentUser {
    return _auth.currentUser;
  }

  // Get User Details by Id
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
      String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Get User Details by Email
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(
      String email) async {
    return await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
  }

  // Get User Details by Phone Number
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByPhoneNumber(
      String phoneNumber) async {
    return await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Events ////////////////////////////////////////////
  // Add Event
  Future<void> addEvent(Map<String, String> event) async {
    await _firestore.collection('events').add(event);
  }

  // Retrieve Events
  Stream<QuerySnapshot<Map<String, dynamic>>> getEvents(String userId) {
    return _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // Edit Event
  Future<void> updateEvent(
      String eventId, Map<String, String> updatedEvent) async {
    await _firestore.collection('events').doc(eventId).update(updatedEvent);
  }

  // Remove Event
  Future<void> removeEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Friends ////////////////////////////////////////////
  // Add Friend
  Future<void> addFriend(Map<String, String> friends) async {
    // Add friend to the user's sub-collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friends['userId'])
        .collection('friends')
        .doc(friends['friendId'])
        .set({'friendId': friends['friendId']});
  }
}
