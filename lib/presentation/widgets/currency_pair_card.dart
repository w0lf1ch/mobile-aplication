import 'package:flutter/material.dart';

import '../controllers/currency_converter_controller.dart';

/// Card responsible for selecting source/target currencies and swapping them.
class CurrencyPairCard extends StatelessWidget {
  const CurrencyPairCard({required this.controller, super.key});

  final CurrencyConverterController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currency pair',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Default pair is EUR / USD, but you can also choose another one',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _CurrencyDropdown(
                    label: 'From',
                    value: controller.fromCurrency,
                    currencies: controller.currencies,
                    onChanged: (value) {
                      if (value != null) {
                        controller.setFromCurrency(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    tooltip: 'Swap currencies',
                    onPressed: controller.currencies.length < 2
                        ? null
                        : controller.swapCurrencies,
                    icon: const Icon(Icons.swap_horiz_rounded),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CurrencyDropdown(
                    label: 'To',
                    value: controller.toCurrency,
                    currencies: controller.currencies,
                    onChanged: (value) {
                      if (value != null) {
                        controller.setToCurrency(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable dropdown for choosing a currency code.
class _CurrencyDropdown extends StatelessWidget {
  const _CurrencyDropdown({
    required this.label,
    required this.value,
    required this.currencies,
    required this.onChanged,
  });

  final String label;
  final String value;
  final Map<String, String> currencies;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final entries = currencies.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return DropdownButtonFormField<String>(
      value: entries.any((entry) => entry.key == value) ? value : null,
      decoration: InputDecoration(labelText: label),
      borderRadius: BorderRadius.circular(16),
      items: entries
          .map(
            (entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Text('${entry.key} · ${entry.value}'),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
