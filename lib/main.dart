import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wandeldagboek2025/core/config/firebase_init.dart';
import 'package:provider/provider.dart';
import 'core/config/app_config.dart';
import 'core/services/logging_service.dart';
import 'core/network/network_service.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/repositories/firebase_user_repository.dart';
import 'features/auth/domain/repositories/user_repository.dart';
import 'features/walks/data/repositories/firestore_walk_repository.dart';
import 'features/walks/domain/repositories/walk_repository.dart';
import 'features/observations/data/repositories/firestore_observation_repository.dart';
import 'features/observations/domain/repositories/observation_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Laad environment variabelen
  await dotenv.load(fileName: ".env");

  // Initialiseer Firebase
  await FirebaseInitializer.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoggingService>(
          create: (_) => LoggingService(),
        ),
        Provider<NetworkService>(
          create: (_) => NetworkService(),
        ),
        Provider<UserRepository>(
          create: (_) => FirebaseUserRepository(),
        ),
        Provider<WalkRepository>(
          create: (_) => FirestoreWalkRepository(),
        ),
        Provider<ObservationRepository>(
          create: (_) => FirestoreObservationRepository(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
