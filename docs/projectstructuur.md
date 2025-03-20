# Projectstructuur Wandeldagboek 2025

Dit document beschrijft de architectuur en structuur van het Wandeldagboek 2025 project.

## Overzicht

Wandeldagboek 2025 is gebouwd met Flutter en volgt een feature-first structuur met Clean Architecture principes. Hierbij wordt de code georganiseerd rond features in plaats van technische lagen.

## Mappenstructuur

```
lib/
├── core/                # Core functionaliteiten
│   ├── config/          # App configuratie
│   ├── errors/          # Error handling
│   ├── network/         # Netwerk services
│   └── utils/           # Utility functies
├── features/            # Feature modules
│   ├── auth/            # Authenticatie
│   │   ├── data/        # Data laag
│   │   ├── domain/      # Domain laag
│   │   └── presentation/# UI laag
│   ├── walks/           # Wandelingen
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── observations/    # Observaties
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/              # Gedeelde code
    ├── models/          # Gedeelde modellen
    ├── providers/       # State management
    └── widgets/         # Herbruikbare widgets
```

## Architectuur per Feature

Elke feature volgt dezelfde structuur:

### Data Laag

Bevat de implementaties voor het ophalen en bewaren van data:
- **Repositories**: Implementaties van de repository interfaces
- **Data Sources**: Remote (API/Firebase) en lokale (SQLite/SharedPrefs) data sources
- **Models**: Data Transfer Objects (DTOs)

### Domain Laag

Bevat de business logica en use cases:
- **Entities**: Business modellen
- **Repositories**: Repository interfaces
- **Use Cases**: Individuele business use cases

### Presentation Laag

Bevat alles gerelateerd aan de gebruikersinterface:
- **Screens**: UI schermen
- **Widgets**: Feature-specifieke widgets
- **View Models / Blocs / Providers**: State management

## State Management

Dit project gebruikt Provider voor state management, met de volgende structuur:
- **AppState**: Globale app state
- **FeatureState**: State per feature
- **Repositories**: Fungeren als bridge tussen providers en data sources

## Navigatie

De app gebruikt Go Router voor navigatie met de volgende structuur:
- **Routes**: Gedefinieerd in `lib/core/routes.dart`
- **Route Guards**: Voor authenticatie en permissie checks
- **Deep Links**: Configuratie voor web en native apps

## Dependencies Injectie

Voor dependencies injectie gebruiken we Provider met een registry pattern:
- **Service Locator**: Globale service locator voor app-wide dependencies
- **Feature Providers**: Providers per feature voor feature-specifieke dependencies

## Testing

De test mappen volgen dezelfde structuur als de code:

```
test/
├── core/
├── features/
│   ├── auth/
│   ├── walks/
│   └── observations/
└── shared/
```

## Assets

Assets zoals afbeeldingen, fonts en JSON-bestanden worden opgeslagen in:

```
assets/
├── images/
├── fonts/
└── json/
```

## Aanbevolen Werkwijze

Bij het ontwikkelen binnen dit project:
1. Respecteer de bestaande architectuur
2. Voeg nieuwe features toe in hun eigen map binnen `features/`
3. Deel herbruikbare code in `shared/` of `core/`
4. Schrijf tests voor alle nieuwe functionaliteit
5. Documenteer complexe onderdelen 