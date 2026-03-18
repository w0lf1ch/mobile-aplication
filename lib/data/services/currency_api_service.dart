import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_defaults.dart';
import '../models/exchange_rate_response.dart';

/// Handles all HTTP communication with the currency API.
///
/// UI widgets never call the internet directly.
/// They ask the controller, and the controller delegates networking to this
/// service. That keeps the code easier to test and easier to read.
class CurrencyApiService {
  CurrencyApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Loads the supported currencies list.
  ///
  /// Result example:
  /// {
  ///   "EUR": "Euro",
  ///   "USD": "United States Dollar"
  /// }
  Future<Map<String, String>> fetchCurrencies() async {
    final uri = Uri.parse('${AppDefaults.apiBaseUrl}/currencies');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load supported currencies (${response.statusCode}).',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body.map((key, value) => MapEntry(key, value.toString()));
  }

  /// Loads a live exchange rate for one currency pair.
  Future<ExchangeRateResponse> fetchExchangeRate({
    required String baseCurrency,
    required String targetCurrency,
  }) async {
    final uri = Uri.parse(
      '${AppDefaults.apiBaseUrl}/latest?base=$baseCurrency&symbols=$targetCurrency',
    );

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load exchange rate (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ExchangeRateResponse.fromJson(body);
  }

  /// Properly disposes the HTTP client when the controller is destroyed.
  void dispose() {
    _client.close();
  }
}
