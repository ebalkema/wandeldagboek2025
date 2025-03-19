import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

Future<void> setupFirebaseCoreMocks() async {
  // Mock voor Firebase Core
  final platformApp = FirebaseAppPlatform(
    'test',
    const FirebaseOptions(
      apiKey: 'test-api-key',
      appId: 'test-app-id',
      messagingSenderId: 'test-sender-id',
      projectId: 'test-project-id',
      databaseURL: 'test-database-url',
      storageBucket: 'test-storage-bucket',
    ),
  );

  final platformInstance = TestFirebaseCoreHostApi();

  FirebasePlatform.instance = platformInstance;

  // Mock voor method channel calls
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_core'),
    (call) async {
      switch (call.method) {
        case 'Firebase#initializeCore':
          return [
            {
              'name': platformApp.name,
              'options': platformApp.options,
              'pluginConstants': {},
            }
          ];
        case 'Firebase#initializeApp':
          return {
            'name': platformApp.name,
            'options': platformApp.options,
          };
        default:
          return null;
      }
    },
  );
}

class TestFirebaseCoreHostApi extends FirebasePlatform {
  TestFirebaseCoreHostApi() : super();

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return FirebaseAppPlatform(
      name,
      const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
        databaseURL: 'test-database-url',
        storageBucket: 'test-storage-bucket',
      ),
    );
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return app(name ?? defaultFirebaseAppName);
  }

  @override
  List<FirebaseAppPlatform> get apps => [app()];
}
