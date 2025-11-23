<p align="center">
  <img src="assets/images/logos/logo.png" alt="BetaVersion Logo" width="120">
</p>

# BetaVersion Flutter Starter

An enterprise-level Flutter starter project by [betaversion.io](https://betaversion.io).

## Features

- Multi-environment support (development, staging, production)
- CI/CD pipelines with GitHub Actions
- Native splash screen configuration
- App icon generation for all platforms
- Clean project structure
- VS Code optimized settings and snippets

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.0
- Dart SDK ^3.10.0

### Installation

```bash
flutter pub get
```

### Running the App

```bash
# Development
flutter run

# Staging
flutter run --flavor staging

# Production
flutter run --flavor production
```

### Generating Assets

```bash
# Generate app icons
dart run flutter_launcher_icons -f icons.yaml

# Generate splash screens
dart run flutter_native_splash:create
```

## Project Structure

```
lib/
├── main.dart          # App entry point
assets/
├── images/            # Image assets
├── icons/             # Icon assets
├── animations/        # Animation files
```

## License

See [LICENSE](LICENSE) for details.
