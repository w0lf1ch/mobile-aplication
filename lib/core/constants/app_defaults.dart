/// Central place for small constants used across the app.
///
/// Having defaults in one file makes them easy to update later without
/// searching through UI or service files.
class AppDefaults {
  static const String defaultFromCurrency = 'EUR';
  static const String defaultToCurrency = 'USD';

  /// Frankfurter provides free exchange rates without an API key.
  static const String apiBaseUrl = 'https://api.frankfurter.dev/v1';
}
