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
  //////////////////////////////////////////// Friends ////////////////////////////////////////////
  // Add Friend
  Future<void> addFriend(Map<String, String> friends) async {
    await _firestore
        .collection('users')
        .doc(friends['userId'])
        .collection('friends')
        .doc(friends['friendId'])
        .set({'friendId': friends['friendId']});
  }

  // Get Friends Ids
  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsIds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .snapshots();
  }

  // Get Friends Details
  Future<QuerySnapshot<Map<String, dynamic>>> getFriendsDetails(
      List<String> friendsIds) async {
    return await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendsIds)
        .get();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Events ////////////////////////////////////////////
  // Add Event
  Future<void> addEvent(Map<String, String> event) async {
    await _firestore.collection('events').add(event);
  }

  // Get Events
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
  //////////////////////////////////////////// Gifts ////////////////////////////////////////////
  // Add Gift
  Future<void> addGift(Map<String, dynamic> gift) async {
    await _firestore.collection('gifts').add(gift);
  }

  // Get Gifts
  Stream<QuerySnapshot> getGiftsByEventId(String eventId) {
    return _firestore
        .collection('gifts')
        .where('eventId', isEqualTo: eventId)
        .snapshots();
  }

  // Get Gift Details
  Stream<DocumentSnapshot> getGiftById(String giftId) {
    return _firestore.collection('gifts').doc(giftId).snapshots();
  }

  // Get Pledged Gifts
  Stream<QuerySnapshot> getPLedgedGift(String userId) {
    return _firestore
        .collection('gifts')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: false)
        .snapshots();
  }

  // Update Gift
  Future<void> updateGift(
      String giftId, Map<String, dynamic> updatedEvent) async {
    await _firestore.collection('gifts').doc(giftId).update(updatedEvent);
  }

  // Pledge Gift
  Future<void> updateGiftStatus(String giftId) async {
    await _firestore.collection('gifts').doc(giftId).update({'status': false});
  }

  // Add Pledged User ID
  Future<void> addPledgedUserName(String giftId, String userName) async {
    await _firestore
        .collection('gifts')
        .doc(giftId)
        .update({'pledgedUserName': userName});
  }

  // Add Pledged Due Date
  Future<void> addPledgedDate(String giftId, String dueDate) async {
    await _firestore
        .collection('gifts')
        .doc(giftId)
        .update({'dueDate': dueDate});
  }

  // Remove Gift
  Future<void> removeGift(String giftId) async {
    await _firestore.collection('gifts').doc(giftId).delete();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
}
