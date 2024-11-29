import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //////////////////////////////////////////// Users ////////////////////////////////////////////

  Future<UserCredential> authSignUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> storeSignUp(String id, Map<String, String> user) async {
    await _firestore.collection('users').doc(id).set(user);
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  get currentUser {
    return _auth.currentUser;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
      String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Events ////////////////////////////////////////////
  // Add Event
  Future<void> addEvent(Map<String, String> event) async {
    await _firestore.collection('events').add(event);
  }

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
}
