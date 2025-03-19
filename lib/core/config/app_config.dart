import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? 'Wandeldagboek';
  static String get environment => dotenv.env['APP_ENV'] ?? 'development';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  // API Configuratie
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.wandeldagboek.nl';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';

  // Feature Flags
  static bool get enablePremiumFeatures =>
      dotenv.env['ENABLE_PREMIUM_FEATURES']?.toLowerCase() == 'true';
  static bool get enableAnalytics =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
}
