import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //////////////////////////////////////////// Users ////////////////////////////////////////////
  /// Sign up Authentication
  Future<UserCredential> authSignUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up Store
  Future<void> storeSignUp(String userId, Map<String, String> user) async {
    await _firestore.collection('users').doc(userId).set(user);
  }

  /// Sign in Authentication
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Update User
  Future<void> updateUser(String userId, Map<String, String> updateData) async {
    await _firestore.collection('users').doc(userId).update(updateData);
  }

  /// Get User Details by Id
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(
      String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  /// Get User Details by Email
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(
      String email) async {
    return await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
  }

  /// Get User Details by Phone Number
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByPhoneNumber(
      String phoneNumber) async {
    return await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();
  }

  /// Get Users Details (Multiple Users at once)
  Future<QuerySnapshot<Map<String, dynamic>>> getUsersDetails(
      List<String> usersIds) async {
    return await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: usersIds)
        .get();
  }

  //////////////////////////////////////////// Friends ////////////////////////////////////////////
  /// Add Friend
  Future<void> addFriend(Map<String, String> friends) async {
    await _firestore
        .collection('users')
        .doc(friends['userId'])
        .collection('friends')
        .doc(friends['friendId'])
        .set({'friendId': friends['friendId']});
  }

  /// Get Friends Ids
  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsIds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .snapshots();
  }

  //////////////////////////////////////////// Events ////////////////////////////////////////////
  /// Add Event
  Future<String> addEvent(Map<String, dynamic> event) async {
    final docRef = await _firestore.collection('events').add(event);
    return docRef.id;
  }

  /// Edit Event
  Future<void> updateEvent(
      String eventId, Map<String, dynamic> updatedEvent) async {
    await _firestore.collection('events').doc(eventId).update(updatedEvent);
  }

  /// Remove Event
  Future<void> removeEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  /// Get Events
  Stream<QuerySnapshot<Map<String, dynamic>>> getEvents(String userId) {
    return _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  //////////////////////////////////////////// Gifts ////////////////////////////////////////////
  /// Add Gift
  Future<void> addGift(Map<String, dynamic> gift) async {
    await _firestore.collection('gifts').add(gift);
  }

  /// Update Gift
  Future<void> updateGift(
      String giftId, Map<String, dynamic> updatedEvent) async {
    await _firestore.collection('gifts').doc(giftId).update(updatedEvent);
  }

  /// Remove Gift
  Future<void> removeGift(String giftId) async {
    await _firestore.collection('gifts').doc(giftId).delete();
  }

  /// Get Gift Details
  Stream<DocumentSnapshot> getGift(String giftId) {
    return _firestore.collection('gifts').doc(giftId).snapshots();
  }

  /// Get Gifts
  Stream<QuerySnapshot<Map<String, dynamic>>> getGiftsByEventId(
      String eventId) {
    return _firestore
        .collection('gifts')
        .where('eventId', isEqualTo: eventId)
        .snapshots();
  }

  /// Get Pledged Gifts
  Stream<QuerySnapshot<Map<String, dynamic>>> getPLedgedGifts(String userId) {
    return _firestore
        .collection('gifts')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: false)
        .orderBy('pledgeDate', descending: true)
        .snapshots();
  }

  /// Get My Pledged Gifts
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyPLedgedGifts(String userId) {
    return _firestore
        .collection('gifts')
        .where('status', isEqualTo: false)
        .where('pledgeUserId', isEqualTo: userId)
        .snapshots();
  }
}
