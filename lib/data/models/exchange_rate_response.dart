/// Model representing the exchange-rate API response.
///
/// Example response from the API:
/// {
///   "amount": 1.0,
///   "base": "EUR",
///   "date": "2026-03-18",
///   "rates": {
///     "USD": 1.09
///   }
/// }
class ExchangeRateResponse {
  const ExchangeRateResponse({
    required this.base,
    required this.date,
    required this.rates,
  });

  /// Base currency used in the request.
  final String base;

  /// Date returned by the API for the shown rate.
  final String date;

  /// Map of target currency code -> rate.
  final Map<String, double> rates;

  /// Converts raw JSON into a strongly typed Dart object.
  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    final ratesJson = json['rates'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return ExchangeRateResponse(
      base: json['base'] as String? ?? '',
      date: json['date'] as String? ?? '',
      rates: ratesJson.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }
}
