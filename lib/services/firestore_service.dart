import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Users ---
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    userData['createdAt'] = FieldValue.serverTimestamp();
    await _db.collection('users').doc(uid).set(userData);
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _db.collection('users').orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> updateUserStatus(String uid, String status) async {
    await _db.collection('users').doc(uid).update({'status': status});
  }

  // --- Lost & Found / Posts ---
  Future<void> createPost(Map<String, dynamic> postData) async {
    postData['createdAt'] = FieldValue.serverTimestamp();
    postData['userId'] = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    await _db.collection('posts').add(postData);
  }

  Stream<QuerySnapshot> getPostsStream(String type) {
    if (type == 'All') {
      return _db.collection('posts').orderBy('createdAt', descending: true).snapshots();
    }
    return _db.collection('posts').where('type', isEqualTo: type).orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> updatePostStatus(String docId, String status) async {
    await _db.collection('posts').doc(docId).update({'status': status});
  }

  Future<void> deletePost(String docId) async {
    await _db.collection('posts').doc(docId).delete();
  }

  // --- Help Requests ---
  Future<void> createHelpRequest(Map<String, dynamic> requestData) async {
    requestData['createdAt'] = FieldValue.serverTimestamp();
    requestData['userId'] = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    await _db.collection('help_requests').add(requestData);
  }

  Stream<QuerySnapshot> getHelpRequestsStream() {
    return _db.collection('help_requests').orderBy('createdAt', descending: true).snapshots();
  }

  // --- Safe Hubs ---
  Stream<QuerySnapshot> getSafeHubsStream() {
    return _db.collection('safe_hubs').snapshots();
  }

  Future<void> updateSafeHubStatus(String docId, String status) async {
    await _db.collection('safe_hubs').doc(docId).update({'status': status});
  }

  // --- Disputes / Frauds ---
  Stream<QuerySnapshot> getDisputesStream() {
    return _db.collection('disputes').snapshots();
  }

  Future<void> deleteDispute(String docId) async {
    await _db.collection('disputes').doc(docId).delete();
  }

  // --- Messages ---
  Stream<QuerySnapshot> getMessagesStream() {
    // In a real app this would be filtered by current user ID
    return _db.collection('messages').orderBy('createdAt', descending: true).snapshots();
  }
}
