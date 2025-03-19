import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../../shared/models/user.dart' as app;
import 'package:flutter/foundation.dart';

class FirebaseUserRepository implements UserRepository {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  FirebaseUserRepository()
      : _auth = firebase_auth.FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        _googleSignIn = GoogleSignIn();

  @visibleForTesting
  FirebaseUserRepository.test(
    this._auth,
    this._firestore,
    this._googleSignIn,
  );

  @override
  Future<app.User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return app.User.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<app.User> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _getOrCreateUser(result.user!);
  }

  @override
  Future<app.User> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign In werd geannuleerd');
    }

    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    return _getOrCreateUser(result.user!);
  }

  @override
  Future<app.User> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return _getOrCreateUser(result.user!, isGuest: true);
  }

  @override
  Future<app.User> signUp(
    String email,
    String password,
    String? displayName,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null) {
      await result.user!.updateDisplayName(displayName);
    }

    return _getOrCreateUser(result.user!);
  }

  @override
  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Geen gebruiker ingelogd');

    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }

    if (photoUrl != null) {
      await user.updatePhotoURL(photoUrl);
    }

    await _updateUserDocument(user.uid, {
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updatePremiumStatus(bool isPremium) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Geen gebruiker ingelogd');

    await _updateUserDocument(user.uid, {
      'isPremium': isPremium,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<app.User?> get(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (!doc.exists) return null;

    return app.User.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<List<app.User>> getAll() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => app.User.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> create(app.User user) async {
    await _firestore.collection('users').doc(user.id).set({
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'isGuest': user.isGuest,
      'isPremium': user.isPremium,
      'lastLoginAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> update(app.User user) async {
    await _updateUserDocument(user.id, {
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'isGuest': user.isGuest,
      'isPremium': user.isPremium,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(String id) async {
    await _firestore.collection('users').doc(id).delete();
  }

  Future<app.User> _getOrCreateUser(
    firebase_auth.User firebaseUser, {
    bool isGuest = false,
  }) async {
    final doc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (!doc.exists) {
      final user = app.User(
        id: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        isGuest: isGuest,
      );

      await create(user);
      return user;
    }

    final userData = doc.data()!..['id'] = doc.id;
    await _updateUserDocument(doc.id, {
      'lastLoginAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return app.User.fromJson(userData);
  }

  Future<void> _updateUserDocument(
      String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}
