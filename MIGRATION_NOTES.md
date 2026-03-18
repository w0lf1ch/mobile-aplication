# Quick fix for an old existing Flutter Android project

If your project already exists and you don't want to replace the whole Android folder,
here are the first things to check.

## 1. MainActivity

Old broken import:

```kotlin
import io.flutter.app.FlutterActivity
```

Correct modern import:

```kotlin
import io.flutter.embedding.android.FlutterActivity
```

## 2. Custom Application class

If you have something like this in Java or Kotlin:

```java
import io.flutter.app.FlutterApplication;
```

replace it with:

```java
import android.app.Application;
```

and extend `Application`, not `FlutterApplication`.

## 3. Old Gradle setup

If your `android/app/build.gradle` uses lines like:

```gradle
apply plugin: 'com.android.application'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
```

migrate to the modern `plugins {}` format.

## 4. settings.gradle

If your `settings.gradle` reads old plugin files manually or uses very old buildscript logic,
replace it with the modern Flutter plugin-loader version from this project.

## 5. Safer migration path

Often the fastest solution is:

```bash
flutter create new_app
```

Then copy:
- `lib/`
- `pubspec.yaml`

from your old app into the fresh project.
