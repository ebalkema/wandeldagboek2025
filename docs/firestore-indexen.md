# Firestore Indexen in Wandeldagboek 2025

Dit document beschrijft de Firestore indexen die worden gebruikt in het Wandeldagboek 2025 project en hoe deze beheerd worden.

## Overzicht

Firestore gebruikt indexen om queries efficiënt uit te voeren. Voor complexe queries (met meerdere filters of sorteringen) zijn samengestelde indexen nodig. Dit project gebruikt verschillende samengestelde indexen voor de belangrijkste collecties.

## Bestaande Indexen

### Observations Collectie

| Collectie | Velden | Sortering | Doel |
|-----------|--------|-----------|------|
| observations | walkId | ASC | Observaties ophalen per wandeling in chronologische volgorde |
| observations | timestamp | ASC | |
| observations | userId | ASC | Observaties ophalen per gebruiker in omgekeerd chronologische volgorde |
| observations | timestamp | DESC | |
| observations | walkId | ASC | Observaties ophalen per wandeling in omgekeerd chronologische volgorde |
| observations | timestamp | DESC | |
| observations | userId | ASC | Observaties ophalen gefilterd op gebruiker en wandeling |
| observations | walkId | ASC | |
| observations | timestamp | DESC | |
| observations | walkId | ASC | Observaties ophalen per wandeling, gesorteerd op aanmaakdatum |
| observations | createdAt | ASC | |
| observations | userId | ASC | Observaties ophalen per gebruiker, gesorteerd op aanmaakdatum |
| observations | createdAt | DESC | |

### Walks Collectie

| Collectie | Velden | Sortering | Doel |
|-----------|--------|-----------|------|
| walks | userId | ASC | Wandelingen ophalen per gebruiker, gesorteerd op startdatum |
| walks | startTime | DESC | |
| walks | userId | ASC | Wandelingen ophalen per gebruiker, gesorteerd op datum |
| walks | date | DESC | |
| walks | status | ASC | Wandelingen ophalen gefilterd op status |
| walks | startTime | DESC | |

## Index Beheer

### Via Firebase Console

Indexen kunnen handmatig worden aangemaakt via de Firebase Console:
1. Ga naar [Firebase Console](https://console.firebase.google.com/)
2. Selecteer het project "wandeldagboek2025"
3. Ga naar Firestore Database > Indexen
4. Klik op "Index toevoegen" en volg de instructies

### Via CLI

Voor geautomatiseerd indexbeheer gebruikt dit project Firebase CLI:

```bash
# Initialiseer Firestore configuratie (eenmalig)
firebase init firestore

# Deploy indexen na wijzigingen
firebase deploy --only firestore:indexes
```

De indexen zijn gedefinieerd in het bestand `firestore.indexes.json` in de projectroot.

### Ontbrekende Indexen

Als je een error krijgt over een ontbrekende index, volg deze stappen:
1. Gebruik de link in de foutmelding om rechtstreeks de index aan te maken
2. Of voeg de index handmatig toe aan `firestore.indexes.json` en deploy

## Aanbevolen Werkwijze

Bij het ontwikkelen van nieuwe features:
1. Test je queries lokaal met de Firebase Emulator
2. Als je een ontbrekende index foutmelding krijgt, maak de index aan
3. Documenteer nieuwe indexen in `firestore.indexes.json`
4. Voeg informatie toe aan dit document als het een belangrijke index is 