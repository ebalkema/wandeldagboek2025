import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/walk_repository.dart';
import '../../../../shared/models/walk.dart';

class FirestoreWalkRepository implements WalkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _walks =>
      _firestore.collection('walks');

  @override
  Future<Walk?> get(String id) async {
    final doc = await _walks.doc(id).get();
    if (!doc.exists) return null;

    return Walk.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<List<Walk>> getAll() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _walks.where('userId', isEqualTo: user.uid).get();
    return snapshot.docs
        .map((doc) => Walk.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<Walk>> getWalksForUser(String userId) async {
    final snapshot = await _walks.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => Walk.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<Walk>> getRecentWalks(String userId, {int limit = 10}) async {
    final snapshot = await _walks
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => Walk.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> create(Walk walk) async {
    await _walks.doc(walk.id).set({
      'userId': walk.userId,
      'title': walk.title,
      'description': walk.description,
      'route': walk.route
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'distance': walk.distance,
      'duration': walk.duration.inSeconds,
      'startTime': walk.startTime.toUtc(),
      'endTime': walk.endTime?.toUtc(),
      'elevationGain': walk.elevationGain,
      'elevationLoss': walk.elevationLoss,
      'photoUrls': walk.photoUrls,
      'observationIds': walk.observationIds,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> update(Walk walk) async {
    await _walks.doc(walk.id).update({
      'title': walk.title,
      'description': walk.description,
      'route': walk.route
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'distance': walk.distance,
      'duration': walk.duration.inSeconds,
      'startTime': walk.startTime.toUtc(),
      'endTime': walk.endTime?.toUtc(),
      'elevationGain': walk.elevationGain,
      'elevationLoss': walk.elevationLoss,
      'photoUrls': walk.photoUrls,
      'observationIds': walk.observationIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(String id) async {
    await _walks.doc(id).delete();
  }

  @override
  Future<void> addPhotoToWalk(String walkId, String photoUrl) async {
    await _walks.doc(walkId).update({
      'photoUrls': FieldValue.arrayUnion([photoUrl]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removePhotoFromWalk(String walkId, String photoUrl) async {
    await _walks.doc(walkId).update({
      'photoUrls': FieldValue.arrayRemove([photoUrl]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> addObservationToWalk(String walkId, String observationId) async {
    await _walks.doc(walkId).update({
      'observationIds': FieldValue.arrayUnion([observationId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeObservationFromWalk(
    String walkId,
    String observationId,
  ) async {
    await _walks.doc(walkId).update({
      'observationIds': FieldValue.arrayRemove([observationId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<Walk> getWalkStream(String walkId) {
    return _walks.doc(walkId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception('Wandeling niet gevonden');
      }
      return Walk.fromJson(doc.data()!..['id'] = doc.id);
    });
  }
}
