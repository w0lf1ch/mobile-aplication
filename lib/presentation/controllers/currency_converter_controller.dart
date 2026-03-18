import 'package:flutter/material.dart';

import '../../core/constants/app_defaults.dart';
import '../../data/services/currency_api_service.dart';

/// State holder for the currency converter screen.
///
/// This class keeps business logic out of widgets.
/// Widgets display data and forward user actions here.
class CurrencyConverterController extends ChangeNotifier {
  CurrencyConverterController(this._apiService) {
    // Recalculate the result every time the user edits the amount.
    amountController.addListener(_handleAmountChanged);

    // Load currencies and the initial rate as soon as the controller is created.
    initialize();
  }

  final CurrencyApiService _apiService;

  /// Text controller for the amount input field.
  final TextEditingController amountController = TextEditingController(text: '1');

  /// Map of currency code -> readable currency name.
  Map<String, String> currencies = <String, String>{};

  /// Current selected source currency.
  String fromCurrency = AppDefaults.defaultFromCurrency;

  /// Current selected target currency.
  String toCurrency = AppDefaults.defaultToCurrency;

  /// API rate, for example 1 EUR = 1.09 USD.
  double exchangeRate = 0;

  /// Date string returned by the API.
  String rateDate = '';

  /// User-friendly error shown in the UI when something fails.
  String? errorMessage;

  /// True while initial data is loading.
  bool isLoading = false;

  /// True while manual refresh is in progress.
  bool isRefreshing = false;

  /// Prevents notifyListeners calls after dispose.
  bool _isDisposed = false;

  /// Parsed numeric amount from the input field.
  ///
  /// We replace commas with dots so both `12,5` and `12.5` work.
  double get amount {
    final normalized = amountController.text.trim().replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  /// Final converted amount shown to the user.
  double get convertedAmount => amount * exchangeRate;

  /// Readable text for the current rate.
  String get formattedRate =>
      '1 $fromCurrency = ${exchangeRate.toStringAsFixed(4)} $toCurrency';

  /// Readable text for the converted amount.
  String get formattedResult => convertedAmount.toStringAsFixed(2);

  /// Initial startup flow:
  /// 1. load supported currencies
  /// 2. validate default pair
  /// 3. fetch the first live rate
  Future<void> initialize() async {
    isLoading = true;
    errorMessage = null;
    _safeNotify();

    try {
      currencies = await _apiService.fetchCurrencies();

      // Make sure the default source currency exists.
      if (!currencies.containsKey(fromCurrency) && currencies.isNotEmpty) {
        fromCurrency = currencies.keys.first;
      }

      // Make sure the default target currency exists.
      if (!currencies.containsKey(toCurrency) && currencies.length > 1) {
        toCurrency = currencies.keys.elementAt(1);
      }

      // Make sure source and target are not identical.
      if (fromCurrency == toCurrency && currencies.length > 1) {
        toCurrency = currencies.keys.firstWhere(
          (code) => code != fromCurrency,
          orElse: () => currencies.keys.first,
        );
      }

      await _fetchExchangeRate();
    } catch (error) {
      errorMessage = _normalizeError(error);
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  /// Called by the refresh button and pull-to-refresh gesture.
  Future<void> refreshRate() async {
    isRefreshing = true;
    errorMessage = null;
    _safeNotify();

    try {
      await _fetchExchangeRate();
    } catch (error) {
      errorMessage = _normalizeError(error);
      _safeNotify();
    } finally {
      isRefreshing = false;
      _safeNotify();
    }
  }

  /// Changes the source currency and reloads the exchange rate.
  Future<void> setFromCurrency(String value) async {
    if (fromCurrency == value) return;

    fromCurrency = value;
    if (fromCurrency == toCurrency) {
      toCurrency = _findAlternativeCurrency(excluding: fromCurrency);
    }
    _safeNotify();
    await refreshRate();
  }

  /// Changes the target currency and reloads the exchange rate.
  Future<void> setToCurrency(String value) async {
    if (toCurrency == value) return;

    toCurrency = value;
    if (toCurrency == fromCurrency) {
      fromCurrency = _findAlternativeCurrency(excluding: toCurrency);
    }
    _safeNotify();
    await refreshRate();
  }

  /// Swaps the conversion direction, for example EUR -> USD becomes USD -> EUR.
  Future<void> swapCurrencies() async {
    final previousFrom = fromCurrency;
    fromCurrency = toCurrency;
    toCurrency = previousFrom;
    _safeNotify();
    await refreshRate();
  }

  /// Rebuilds the UI when the user edits the amount text.
  void _handleAmountChanged() {
    _safeNotify();
  }

  /// Internal helper that requests the current pair rate from the API.
  Future<void> _fetchExchangeRate() async {
    // If both currencies are the same, the rate is always 1.
    if (fromCurrency == toCurrency) {
      exchangeRate = 1;
      rateDate = 'Same currency pair';
      _safeNotify();
      return;
    }

    final response = await _apiService.fetchExchangeRate(
      baseCurrency: fromCurrency,
      targetCurrency: toCurrency,
    );

    final rate = response.rates[toCurrency];
    if (rate == null) {
      throw Exception('Rate for $toCurrency was not returned by the API.');
    }

    exchangeRate = rate;
    rateDate = response.date;
    _safeNotify();
  }

  /// Finds any other currency code to avoid duplicate source/target values.
  String _findAlternativeCurrency({required String excluding}) {
    if (currencies.isEmpty) return excluding;

    return currencies.keys.firstWhere(
      (currency) => currency != excluding,
      orElse: () => excluding,
    );
  }

  /// Makes technical exceptions more readable for the UI.
  String _normalizeError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  /// Prevents updates after the controller has already been disposed.
  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    amountController
      ..removeListener(_handleAmountChanged)
      ..dispose();
    _apiService.dispose();
    super.dispose();
  }
}
