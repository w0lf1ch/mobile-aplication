# Currency Converter Flutter App (Android v2 embedding fixed)

This project is a clean Flutter app for Android that:

- loads the latest exchange rate from an API,
- converts an entered amount,
- lets the user swap conversion direction,
- lets the user refresh the API manually,
- supports choosing another currency pair (bonus requirement).

## Why your old build failed

The Android error **"Build failed due to use of deleted Android v1 embedding"** happens when an old Flutter Android project still references classes from `io.flutter.app.*`.

Modern Flutter Android projects must use:

- `io.flutter.embedding.android.FlutterActivity`
- declarative Gradle plugins (`plugins {}`)
- a modern `settings.gradle` plugin loader

This fixed project already uses the Android **v2 embedding**.

## Project structure

```text
lib/
  app.dart
  main.dart
  core/constants/app_defaults.dart
  data/models/exchange_rate_response.dart
  data/services/currency_api_service.dart
  presentation/controllers/currency_converter_controller.dart
  presentation/screens/home_screen.dart
  presentation/widgets/
    amount_input_card.dart
    conversion_result_card.dart
    currency_pair_card.dart
    rate_info_card.dart

android/
  build.gradle
  settings.gradle
  app/build.gradle
  app/src/main/AndroidManifest.xml
  app/src/main/kotlin/com/example/flutter_currency_converter/MainActivity.kt
```

## Run

If the project is missing any generated platform helper files on your machine, run this once first:

```bash
flutter create .
```

Then run:

```bash
flutter pub get
flutter run
```

## If you want to move this into your existing project

The safest approach is:

1. Create a fresh Flutter project with your current Flutter SDK.
2. Replace the `lib/` folder and `pubspec.yaml` with the ones from this project.
3. Copy the Android files only if your current Android folder is old or broken.

That avoids most migration issues from very old Gradle / embedding setups.
