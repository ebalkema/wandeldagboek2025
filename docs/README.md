# Wandeldagboek 2025

Een Flutter-applicatie voor het bijhouden en delen van wandelingen, inclusief locaties, observaties en multimedia.

## Functionaliteiten

- **Gebruikersauthenticatie**: Inloggen, registreren en anoniem gebruik via Firebase Authentication
- **Wandelingen registreren**: Start, pauzeer en stop wandelingen met GPS-tracking
- **Observaties maken**: Leg interessante waarnemingen vast tijdens wandelingen (planten, dieren, landschappen)
- **Multimedia ondersteuning**: Foto's, video's en audio toevoegen aan observaties
- **Kaartweergave**: Bekijk wandelroutes en observaties op een interactieve kaart
- **Achtergrondtracking**: Blijf je wandeling bijhouden, zelfs als de app op de achtergrond staat

## Architectuur

De app is gebouwd volgens een feature-first structuur met Clean Architecture principes:

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

3.5. Configureer Firestore indexen:
   - Zorg ervoor dat de benodigde Firestore indexen zijn aangemaakt
   - Gebruik de volgende composite index voor de `observations` collectie:
     - Velden: `walkId` (oplopend), `timestamp` (oplopend)
   - Deze index kan worden aangemaakt via:
     - Firebase Console > Firestore > Indexen
     - Of via CLI: `firebase deploy --only firestore:indexes`
   - Zie `firestore.indexes.json` voor de volledige index configuratie

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

### Debug Protocol
Voor het debuggen van de web versie:
```bash
# 1. Ga naar de juiste directory
cd /Users/erwinbalkema/wandeldagboek2025v1

# 2. Build de web versie met debug opties
flutter build web --dart-define=FLUTTER_WEB_DEBUG=true

# 3. Start de server
cd build/web && python3 -m http.server 8080
```

### Deploy Protocol
Voor het deployen van de web versie:
```bash
# 1. Ga naar de juiste directory
cd /Users/erwinbalkema/wandeldagboek2025v1

# 2. Build de web versie voor productie
flutter build web --release

# 3. Deploy naar Firebase Hosting
firebase deploy --only hosting
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