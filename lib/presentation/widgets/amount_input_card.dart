import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/currency_converter_controller.dart';

/// Card responsible only for amount input.
class AmountInputCard extends StatelessWidget {
  const AmountInputCard({required this.controller, super.key});

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
              'Amount',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type the amount you want to convert.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),

              // Allows only digits, comma and dot.
              // This keeps the input simple and reduces parsing errors.
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.edit_outlined),
                suffixText: controller.fromCurrency,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
