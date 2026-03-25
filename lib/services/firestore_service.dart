import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/calculation.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> ensureAuthenticated() async {
    if (_auth.currentUser != null) {
      return;
    }

    await _auth.signInAnonymously();
  }

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('User is not authenticated.');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _historyCollection {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('history');
  }

  Stream<List<Calculation>> historyStream() {
    return _historyCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Calculation.fromFirestore(
                  doc.data(),
                  firestoreId: doc.id,
                ),
              )
              .toList(),
        );
  }

  Future<void> addCalculation(Calculation calculation) async {
    await _historyCollection.add(calculation.toFirestore());
  }

  Future<void> clearHistory() async {
    final snapshot = await _historyCollection.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
