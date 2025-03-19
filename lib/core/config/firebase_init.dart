import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_config.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: FirebaseConfig.currentPlatform,
      );
      debugPrint('Firebase is succesvol geïnitialiseerd');
    } catch (e) {
      debugPrint('Fout bij het initialiseren van Firebase: $e');
      rethrow;
    }
  }
}
