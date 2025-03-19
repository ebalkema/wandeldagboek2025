import 'package:logging/logging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();

  final _logger = Logger('Wandeldagboek');
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
      if (record.error != null) {
        print('Error: ${record.error}');
        if (record.stackTrace != null) {
          print('Stack trace: ${record.stackTrace}');
        }
      }
    });

    _isInitialized = true;
  }

  void debug(String message) {
    _logger.fine(message);
  }

  void info(String message) {
    _logger.info(message);
  }

  void warning(String message) {
    _logger.warning(message);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
    if (error != null) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  void setUserIdentifier(String userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }
}
