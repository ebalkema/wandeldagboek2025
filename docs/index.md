# Wandeldagboek 2025 Documentatie

Welkom bij de documentatie van Wandeldagboek 2025.

## Belangrijke documenten

- [README](README.md) - Overzicht en setup van het project
- [Bijdragen](CONTRIBUTING.md) - Richtlijnen voor bijdragen aan het project
- [Changelog](CHANGELOG.md) - Geschiedenis van wijzigingen
- [Firebase Integratie](firebase-integratie.md) - Gedetailleerde informatie over Firebase integratie
- [Firestore Indexen](firestore-indexen.md) - Documentatie over de Firestore indexen
- [Projectstructuur](projectstructuur.md) - Architectuur en structuur van het project

## Firestore Indexen

Voor efficiënte queries in Firestore maakt dit project gebruik van verschillende indexen:

- `observations`: (walkId ASC, timestamp ASC) - Voor het ophalen van observaties per wandeling in chronologische volgorde
- `walks`: (userId ASC, startTime DESC) - Voor het ophalen van wandelingen per gebruiker, gesorteerd op startdatum

Zie [Firestore Indexen](firestore-indexen.md) voor meer details.

## Firebase Integratie

Dit project maakt gebruik van Firebase voor:
- Authenticatie (email/wachtwoord en Google Sign In)
- Firestore database voor het opslaan van wandelingen en observaties
- Firebase Storage voor het opslaan van afbeeldingen
- Firebase Hosting voor het publiceren van de web versie

Zie [Firebase Integratie](firebase-integratie.md) voor meer details.

## Ontwikkeling

Zie de [CONTRIBUTING](CONTRIBUTING.md) richtlijnen voor meer informatie over de ontwikkelingsprocessen.

Voor een gedetailleerd overzicht van de projectstructuur en architectuur, zie de [Projectstructuur](projectstructuur.md) documentatie. 