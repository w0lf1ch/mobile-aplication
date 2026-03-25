import 'package:flutter/material.dart';

import '../controllers/history_controller.dart';
import '../models/calculation.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HistoryController();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final shouldClear = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF2C2C2E),
                      title: const Text('Clear history?', style: TextStyle(color: Colors.white)),
                      content: const Text(
                        'This will remove all saved calculations from Firestore for the current user.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (!shouldClear) {
                return;
              }

              await controller.clearHistory();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Calculation>>(
        stream: controller.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _MessageState(
              title: 'Failed to load history',
              subtitle: snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9500)),
            );
          }

          final calculations = snapshot.data ?? const [];

          if (calculations.isEmpty) {
            return const _MessageState(
              title: 'No history yet',
              subtitle: 'Complete a calculation to save it to Firestore.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: calculations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final calculation = calculations[index];
              return _HistoryCard(calculation: calculation);
            },
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Calculation calculation;

  const _HistoryCard({required this.calculation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            calculation.historyLine,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            calculation.formattedTime,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _MessageState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white60, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
