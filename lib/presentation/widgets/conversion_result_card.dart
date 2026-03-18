import 'package:flutter/material.dart';

import '../controllers/currency_converter_controller.dart';

/// Shows the final conversion result.
class ConversionResultCard extends StatelessWidget {
  const ConversionResultCard({required this.controller, super.key});

  final CurrencyConverterController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Converted result',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${controller.amount.toStringAsFixed(2)} ${controller.fromCurrency}',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            '${controller.formattedResult} ${controller.toCurrency}',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
