import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/observation_repository.dart';
import '../../../../shared/models/observation.dart';

class FirestoreObservationRepository implements ObservationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _observations =>
      _firestore.collection('observations');

  @override
  Future<Observation?> get(String id) async {
    final doc = await _observations.doc(id).get();
    if (!doc.exists) return null;

    return Observation.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<List<Observation>> getAll() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot =
        await _observations.where('userId', isEqualTo: user.uid).get();
    return snapshot.docs
        .map((doc) => Observation.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<Observation>> getObservationsForWalk(String walkId) async {
    final snapshot =
        await _observations.where('walkId', isEqualTo: walkId).get();
    return snapshot.docs
        .map((doc) => Observation.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<Observation>> getObservationsForUser(String userId) async {
    final snapshot =
        await _observations.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => Observation.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<Observation>> getObservationsByType(ObservationType type) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _observations
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: type.toString())
        .get();
    return snapshot.docs
        .map((doc) => Observation.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> create(Observation observation) async {
    await _observations.doc(observation.id).set({
      'walkId': observation.walkId,
      'userId': observation.userId,
      'type': observation.type.toString(),
      'title': observation.title,
      'description': observation.description,
      'location': {
        'lat': observation.location.latitude,
        'lng': observation.location.longitude,
      },
      'photoUrls': observation.photoUrls,
      'metadata': observation.metadata,
      'timestamp': observation.timestamp.toUtc(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> update(Observation observation) async {
    await _observations.doc(observation.id).update({
      'type': observation.type.toString(),
      'title': observation.title,
      'description': observation.description,
      'location': {
        'lat': observation.location.latitude,
        'lng': observation.location.longitude,
      },
      'photoUrls': observation.photoUrls,
      'metadata': observation.metadata,
      'timestamp': observation.timestamp.toUtc(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(String id) async {
    await _observations.doc(id).delete();
  }

  @override
  Future<void> addPhotoToObservation(
    String observationId,
    String photoUrl,
  ) async {
    await _observations.doc(observationId).update({
      'photoUrls': FieldValue.arrayUnion([photoUrl]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removePhotoFromObservation(
    String observationId,
    String photoUrl,
  ) async {
    await _observations.doc(observationId).update({
      'photoUrls': FieldValue.arrayRemove([photoUrl]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateMetadata(
    String observationId,
    Map<String, dynamic> metadata,
  ) async {
    await _observations.doc(observationId).update({
      'metadata': metadata,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<Observation> getObservationStream(String observationId) {
    return _observations.doc(observationId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception('Observatie niet gevonden');
      }
      return Observation.fromJson(doc.data()!..['id'] = doc.id);
    });
  }
}
