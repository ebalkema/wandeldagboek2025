import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../shared/models/user.dart';
import '../../../../core/repositories/base_repository.dart';

abstract class UserRepository extends BaseRepository<User> {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> signInWithGoogle();
  Future<User> signInAnonymously();
  Future<User> signUp(String email, String password, String? displayName);
  Future<void> signOut();
  Future<void> updateProfile({String? displayName, String? photoUrl});
  Future<void> updatePremiumStatus(bool isPremium);
  Stream<firebase_auth.User?> get authStateChanges;
}
