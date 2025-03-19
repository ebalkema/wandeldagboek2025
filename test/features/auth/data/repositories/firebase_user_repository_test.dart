import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wandeldagboek2025/features/auth/data/repositories/firebase_user_repository.dart';
import 'package:wandeldagboek2025/shared/models/user.dart' as app;
import '../../../../helpers/firebase_auth_mocks.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  setupFirebaseAuthMocks();

  late FirebaseUserRepository repository;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnapshot;
  late MockCollectionReference mockCollectionRef;
  late MockGoogleSignIn mockGoogleSignIn;

  setUpAll(() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
        databaseURL: 'test-database-url',
        storageBucket: 'test-storage-bucket',
      ),
    );
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockDocRef = MockDocumentReference();
    mockDocSnapshot = MockDocumentSnapshot();
    mockCollectionRef = MockCollectionReference();
    mockGoogleSignIn = MockGoogleSignIn();

    // Injecteer de mocks
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockFirestore.collection('users')).thenReturn(mockCollectionRef);
    when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
    when(() => mockDocSnapshot.exists).thenReturn(true);
    when(() => mockDocSnapshot.id).thenReturn('test-uid');
    when(() => mockDocSnapshot.data()).thenReturn({
      'email': 'test@example.com',
      'displayName': 'Test User',
      'photoUrl': null,
      'isGuest': false,
      'isPremium': false,
    });
    when(() => mockUser.updateDisplayName(any())).thenAnswer((_) async {});
    when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});
    when(() => mockGoogleSignIn.isSignedIn()).thenAnswer((_) async => false);
    when(() => mockDocRef.update(any())).thenAnswer((_) async {});

    // Maak een nieuwe repository met de mocks
    repository =
        FirebaseUserRepository.test(mockAuth, mockFirestore, mockGoogleSignIn);
  });

  group('getCurrentUser', () {
    test('retourneert de huidige gebruiker wanneer ingelogd', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act
      final user = await repository.getCurrentUser();

      // Assert
      expect(user, isNotNull);
      expect(user?.email, equals('test@example.com'));
    });

    test('retourneert null wanneer niet ingelogd', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act
      final user = await repository.getCurrentUser();

      // Assert
      expect(user, isNull);
    });
  });

  group('signInWithEmailAndPassword', () {
    test('logt succesvol in met email en wachtwoord', () async {
      // Arrange
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);

      // Act
      final user = await repository.signInWithEmailAndPassword(
        'test@example.com',
        'password123',
      );

      // Assert
      expect(user, isNotNull);
      expect(user.email, equals('test@example.com'));
      verify(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('gooit een exception bij ongeldige inloggegevens', () async {
      // Arrange
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrong-password',
          )).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      // Act & Assert
      expect(
        () => repository.signInWithEmailAndPassword(
          'test@example.com',
          'wrong-password',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('signUp', () {
    test('registreert succesvol een nieuwe gebruiker', () async {
      // Arrange
      when(() => mockAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);

      // Act
      final user = await repository.signUp(
        'new@example.com',
        'password123',
        'New User',
      );

      // Assert
      expect(user, isNotNull);
      expect(user.email, equals('test@example.com'));
      verify(() => mockAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password123',
          )).called(1);
      verify(() => mockUser.updateDisplayName('New User')).called(1);
    });
  });

  group('signOut', () {
    test('logt succesvol uit', () async {
      // Arrange
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      // Act
      await repository.signOut();

      // Assert
      verify(() => mockAuth.signOut()).called(1);
    });
  });
}
