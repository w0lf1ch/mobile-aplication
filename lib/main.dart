import 'package:flutter/material.dart';

import 'app.dart';

/// Entry point of the whole Flutter application.
///
/// `WidgetsFlutterBinding.ensureInitialized()` makes sure Flutter is fully
/// prepared before we start the app. It is especially useful when an app
/// needs to do async or platform setup before `runApp()`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CurrencyConverterApp());
}
