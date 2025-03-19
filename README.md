# Wandeldagboek 2025

Een moderne Flutter applicatie voor het bijhouden van je wandelingen, met focus op natuurbeleving en observaties.

## Features

- 🔐 Authenticatie met email/wachtwoord en Google Sign In
- 🗺️ Wandelingen registreren met GPS tracking
- 📝 Observaties toevoegen met foto's en beschrijvingen
- 🌿 Planten en dieren identificeren
- 📊 Statistieken en voortgang bekijken
- 💫 Premium features voor enthousiaste wandelaars

## Technische Stack

- Flutter 3.29.2
- Firebase (Authentication, Firestore, Storage)
- Google Maps
- Google Sign In
- Provider voor state management
- Go Router voor navigatie

## Setup

1. Clone het repository:
```bash
git clone https://github.com/[gebruikersnaam]/wandeldagboek2025.git
cd wandeldagboek2025
```

2. Installeer dependencies:
```bash
flutter pub get
```

3. Configureer Firebase:
   - Maak een Firebase project aan
   - Voeg de `google-services.json` toe aan `android/app/`
   - Voeg de `GoogleService-Info.plist` toe aan `ios/Runner/`

4. Configureer environment variabelen:
   - Kopieer `.env.example` naar `.env`
   - Vul de benodigde API keys in

5. Start de app:
```bash
flutter run
```

## Ontwikkeling

### Code Style
Dit project volgt de officiële [Dart style guide](https://dart.dev/guides/language/effective-dart/style).

### Tests
Run de tests met:
```bash
flutter test
```

### Build
Build een release versie:
```bash
flutter build apk --release  # Voor Android
flutter build ios --release  # Voor iOS
```

## Project Structuur

```
lib/
├── core/
│   ├── config/         # App configuratie
│   ├── errors/         # Error handling
│   ├── network/        # Netwerk services
│   └── utils/          # Utility functies
├── features/
│   ├── auth/          # Authenticatie
│   ├── walks/         # Wandelingen
│   └── observations/  # Observaties
└── shared/
    ├── models/        # Gedeelde modellen
    ├── providers/     # State management
    └── widgets/       # Herbruikbare widgets
```

## Bijdragen

Zie [CONTRIBUTING.md](CONTRIBUTING.md) voor details over hoe je kunt bijdragen aan dit project.

## Licentie

Dit project is gelicentieerd onder de MIT License - zie het [LICENSE](LICENSE) bestand voor details.
