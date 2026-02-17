# Quira

Quira is a Flutter quiz app built with a layered architecture and clean data flow.  
The project emphasizes readability, simple structure, and resilient handling of external/local data.

## Highlights

- Layered architecture: `presentation`, `domain`, `data`
- Local quiz catalog from JSON mocks
- Local attempt history with `SharedPreferences`
- DTO-to-Entity boundary between data and domain layers
- App-wide typed error model with user-friendly messages
- Localization support (`en`, `pt`)
- Typed quiz language selection via `AppLanguage` enum
- Centralized UI theme tokens (`AppSpacing`, `AppRadius`, `AppStyles`, etc.)

## Tech Stack

- Flutter / Dart
- `get_it` for dependency injection
- `shared_preferences` for local persistence
- `flutter_localizations` + `intl` for i18n

## Architecture Overview

The app follows this flow:

1. `DataSource` reads/writes external data and only works with DTOs
2. `Repository` maps between DTOs and domain entities
3. `UseCase` coordinates domain actions
4. `Presentation` (pages + controllers) consumes use cases

Core folders:

- `lib/layers/presentation`
- `lib/layers/domain`
- `lib/layers/data`
- `lib/core`

## Project Structure

```text
lib/
  core/
    errors/
    inject/
    language/
    parsers/
    theme/
  l10n/
  layers/
    data/
      datasources/
      dtos/
      repositories/
    domain/
      entities/
      repositories/
      usecases/
    presentation/
      controllers/
      extensions/
      pages/
  mocks/
```

## Localization

Localization resources live in:

- `lib/l10n/app_en.arb`
- `lib/l10n/app_pt.arb`
- `l10n.yaml`

Generate localization files with:

```powershell
flutter gen-l10n
```

## Theming and UI Tokens

Design tokens and shared styles live in `lib/core/theme/`:

- `app_spacing.dart`
- `app_radius.dart`
- `app_sizes.dart`
- `app_font_sizes.dart`
- `app_elevation.dart`
- `app_styles.dart`
- `app_theme.dart`

## Getting Started

```powershell
flutter pub get
flutter run
```

## Quiz Catalogs

Quiz content is loaded by language from:

- `lib/mocks/quizzes_en.json` (`en`)
- `lib/mocks/quizzes_pt.json` (`pt`)
