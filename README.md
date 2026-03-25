# Calculator App with Firestore History

This version matches the assignment requirements:

- separate **History** screen
- every record contains the calculation line, for example `4 * 5 = 20`
- every record contains the calculation time, for example `2026-03-25 15:30`
- history is saved in **Cloud Firestore**
- access is limited to the author of the record through **Firebase Authentication + Firestore Security Rules**

## Project structure

```text
lib/
├── controllers/
│   ├── calculator_controller.dart
│   ├── converter_controller.dart
│   └── history_controller.dart
├── models/
│   └── calculation.dart
├── services/
│   └── firestore_service.dart
├── views/
│   ├── calculator_view.dart
│   ├── converter_view.dart
│   └── history_view.dart
├── widgets/
│   └── calculator_button.dart
└── main.dart
```

## What changed

- removed SQLite from the history flow
- kept a dedicated **History** screen
- all calculations are saved to Firestore
- added anonymous sign-in so every device gets its own user id
- security rules allow only the current authenticated user to read or change their own history

## Firebase setup

Do this from the project opened in Android Studio.

### 1. Create or open a Firebase project

In Firebase Console:

- create a project or use an existing one
- add an **Android app**
- use your Android package name from the Flutter project
- download `google-services.json`
- place `google-services.json` into `android/app/`

### 2. Enable services

In Firebase Console:

- enable **Cloud Firestore**
- enable **Anonymous Authentication** in Authentication -> Sign-in method

### 3. Publish the Firestore rules

Copy the contents of `firestore_rules/firestore.rules` into Firebase Console -> Firestore Database -> Rules and publish them.

## Run in Android Studio terminal

```bash
flutter pub get
flutter run
```

## How security works

History is stored under this path:

```text
users/{uid}/history/{historyId}
```

Because of the Firestore rules, a signed-in user can only read, create, update, or delete documents inside their own `users/{uid}/history` path.

## Notes for presentation

You can explain the assignment like this:

1. the user solves a calculation in the calculator screen
2. the app creates a history record with expression, result, and timestamp
3. the record is written to Firestore
4. the History screen reads the current user's records as a live stream
5. Firestore rules make sure one user cannot access another user's history
