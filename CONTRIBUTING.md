# Bijdragen aan Wandeldagboek 2025

Bedankt voor je interesse in het bijdragen aan Wandeldagboek 2025! Dit document bevat richtlijnen en instructies voor het bijdragen aan het project.

## Ontwikkelomgeving Setup

1. Fork het repository
2. Clone je fork:
```bash
git clone https://github.com/[jouw-gebruikersnaam]/wandeldagboek2025.git
cd wandeldagboek2025
```

3. Voeg de upstream remote toe:
```bash
git remote add upstream https://github.com/[originele-gebruikersnaam]/wandeldagboek2025.git
```

4. Installeer dependencies:
```bash
flutter pub get
```

## Code Style

- Volg de officiële [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Gebruik betekenisvolle variabele en functienamen
- Voeg documentatie toe voor complexe logica
- Houd functies kort en gefocust

## Git Workflow

1. Maak een nieuwe branch voor je feature:
```bash
git checkout -b feature/jouw-feature-naam
```

2. Commit je wijzigingen:
```bash
git commit -m "feat: beschrijving van je wijziging"
```

3. Push naar je fork:
```bash
git push origin feature/jouw-feature-naam
```

4. Maak een Pull Request aan

## Commit Berichten

Gebruik de volgende format voor commit berichten:
```
type(scope): beschrijving

[optioneel: uitgebreide beschrijving]
```

Types:
- feat: Nieuwe feature
- fix: Bug fix
- docs: Documentatie wijzigingen
- style: Code style wijzigingen
- refactor: Code refactoring
- test: Test toevoegen of wijzigen
- chore: Algemene onderhoudstaken

## Tests

- Schrijf unit tests voor nieuwe functionaliteit
- Zorg dat alle tests slagen voordat je een PR indient
- Run de tests met:
```bash
flutter test
```

## Pull Requests

1. Update je branch met de laatste wijzigingen:
```bash
git fetch upstream
git rebase upstream/main
```

2. Los eventuele conflicten op
3. Push je wijzigingen
4. Maak een Pull Request aan met:
   - Een duidelijke titel
   - Een beschrijving van de wijzigingen
   - Screenshots (indien relevant)
   - Test resultaten

## Code Review

- Reageer op feedback van reviewers
- Los eventuele problemen op
- Push nieuwe commits indien nodig

## Releases

- Versies worden gemarkeerd met Git tags
- Changelog wordt bijgewerkt in CHANGELOG.md
- Releases worden gemaakt via GitHub Releases

## Contact

Heb je vragen? Neem contact op via:
- GitHub Issues
- [Project Maintainer Email]

Bedankt voor je bijdrage! 