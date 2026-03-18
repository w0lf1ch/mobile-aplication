import 'package:flutter/material.dart';

import '../../data/services/currency_api_service.dart';
import '../controllers/currency_converter_controller.dart';
import '../widgets/amount_input_card.dart';
import '../widgets/conversion_result_card.dart';
import '../widgets/currency_pair_card.dart';
import '../widgets/rate_info_card.dart';

/// Main screen of the app.
///
/// This screen creates the controller, listens to its state changes through
/// `AnimatedBuilder`, and arranges the UI sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CurrencyConverterController _controller;

  @override
  void initState() {
    super.initState();

    // Dependency creation is done here for simplicity.
    // In a larger project, this could come from dependency injection.
    _controller = CurrencyConverterController(CurrencyApiService());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Currency Converter',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                tooltip: 'Refresh rate',
                onPressed: _controller.isLoading || _controller.isRefreshing
                    ? null
                    : _controller.refreshRate,
                icon: _controller.isRefreshing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      )
                    : const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _controller.refreshRate,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSection(controller: _controller),
                  const SizedBox(height: 20),
                  if (_controller.isLoading && _controller.currencies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    AmountInputCard(controller: _controller),
                    const SizedBox(height: 16),
                    CurrencyPairCard(controller: _controller),
                    const SizedBox(height: 16),
                    RateInfoCard(controller: _controller),
                    const SizedBox(height: 16),
                    ConversionResultCard(controller: _controller),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Top gradient card that summarizes the current conversion state.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.controller});

  final CurrencyConverterController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF365CF5), Color(0xFF6B8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22365CF5),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live API rate converter',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter an amount, switch the direction, refresh the API, and even select another currency pair.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.90),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(
                icon: Icons.sync_alt_rounded,
                label: '${controller.fromCurrency} → ${controller.toCurrency}',
              ),
              _InfoChip(
                icon: Icons.payments_outlined,
                label: controller.formattedRate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small reusable badge used inside the header section.
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
