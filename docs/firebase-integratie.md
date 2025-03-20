# Firebase Integratie in Wandeldagboek 2025

Dit document beschrijft hoe Firebase wordt gebruikt in het Wandeldagboek 2025 project.

## Gebruikte Firebase Diensten

Dit project maakt gebruik van de volgende Firebase diensten:

1. **Firebase Authentication**
   - Email/wachtwoord authenticatie
   - Google Sign In
   - Anonieme authenticatie

2. **Cloud Firestore**
   - Opslag van gebruikersgegevens
   - Wandelingen en bijbehorende routes
   - Observaties met metadata

3. **Firebase Storage**
   - Opslag van afbeeldingen voor observaties
   - Gebruikersprofielfoto's

4. **Firebase Hosting**
   - Hosting van de webapplicatie

## Firebase Project Configuratie

### Web Applicatie

De Firebase configuratie voor de web applicatie zit in:
- `web/firebase-config.js` of geïntegreerd in `index.html`

### Android

De Firebase configuratie voor Android is te vinden in:
- `android/app/google-services.json`

### iOS

De Firebase configuratie voor iOS is te vinden in:
- `ios/Runner/GoogleService-Info.plist`

## Security Rules

De security rules bepalen wie toegang heeft tot welke data:

- **Firestore**: Rules bevinden zich in `firestore.rules`
- **Storage**: Rules bevinden zich in `storage.rules`

## Collecties en Schema's

### Users Collection

```
users/{userId}
  - displayName: string
  - email: string
  - photoURL: string
  - createdAt: timestamp
  - lastLoginAt: timestamp
  - preferences: map
    - theme: string
    - notifications: boolean
    - ...
```

### Walks Collection

```
walks/{walkId}
  - userId: string (reference naar user)
  - title: string
  - description: string
  - startTime: timestamp
  - endTime: timestamp
  - duration: number (in seconden)
  - distance: number (in meters)
  - status: string (active, paused, completed)
  - route: array van geopoints
  - createdAt: timestamp
  - updatedAt: timestamp
```

### Observations Collection

```
observations/{observationId}
  - userId: string (reference naar user)
  - walkId: string (reference naar walk)
  - title: string
  - description: string
  - location: geopoint
  - timestamp: timestamp
  - images: array van strings (URLs naar Storage)
  - tags: array van strings
  - createdAt: timestamp
  - updatedAt: timestamp
```

## Best Practices

### Offline Support

Dit project maakt gebruik van Firestore offline capabilities:

```dart
FirebaseFirestore.instance.settings = 
    Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
```

### Batch Operations

Voor het uitvoeren van meerdere schrijfoperaties gebruiken we batches:

```dart
final batch = FirebaseFirestore.instance.batch();
// Voeg operaties toe aan batch
// ...
await batch.commit();
```

### Security Practices

- Gebruik altijd Firebase Authentication
- Implementeer strenge security rules
- Valideer data op client én server
- Gebruik transacties voor real-time updates

## Troubleshooting

### Veelvoorkomende Problemen

1. **Ontbrekende Indexen**: Zie [Firestore Indexen](firestore-indexen.md)
2. **Authentication Fouten**: Controleer de Firebase console voor error logs
3. **Deployment Issues**: Gebruik `firebase deploy --debug` voor gedetailleerde logs 