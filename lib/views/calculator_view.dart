import 'package:flutter/material.dart';

import '../controllers/calculator_controller.dart';
import '../widgets/calculator_button.dart';
import 'converter_view.dart';
import 'history_view.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final CalculatorController _controller = CalculatorController();
  String _display = '0';

  void _onDigit(String digit) {
    setState(() {
      _controller.inputDigit(digit);
      _display = _controller.currentInput;
    });
  }

  void _onOperator(String operator) {
    setState(() {
      _controller.inputOperator(operator);
      _display = _controller.currentInput;
    });
  }

  Future<void> _onEquals() async {
    await _controller.calculate();
    setState(() {
      _display = _controller.currentInput;
    });
  }

  void _onClear() {
    setState(() {
      _controller.clear();
      _display = '0';
    });
  }

  void _onBackspace() {
    setState(() {
      _controller.backspace();
      _display = _controller.currentInput;
    });
  }

  void _onPercent() {
    setState(() {
      _controller.applyPercent();
      _display = _controller.currentInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Km to mile converter',
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConverterView()),
              );
            },
          ),
          IconButton(
            tooltip: 'History',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildRow(['C', '⌫', '%', '/']),
                  _buildRow(['7', '8', '9', '*']),
                  _buildRow(['4', '5', '6', '-']),
                  _buildRow(['1', '2', '3', '+']),
                  _buildRow(['00', '0', '.', '=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) {
          final isOperator = ['+', '-', '*', '/', '='].contains(label);
          final isAction = ['C', '⌫', '%'].contains(label);

          Color backgroundColor;
          Color textColor = Colors.white;

          if (label == '=') {
            backgroundColor = const Color(0xFFFF9500);
          } else if (isOperator) {
            backgroundColor = const Color(0xFFFF9500).withOpacity(0.8);
          } else if (isAction) {
            backgroundColor = const Color(0xFF2C2C2E);
            textColor = const Color(0xFFFF9500);
          } else {
            backgroundColor = const Color(0xFF3A3A3C);
          }

          return Expanded(
            child: CalculatorButton(
              label: label,
              backgroundColor: backgroundColor,
              textColor: textColor,
              onTap: () => _handleButton(label),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleButton(String label) {
    switch (label) {
      case 'C':
        _onClear();
        break;
      case '⌫':
        _onBackspace();
        break;
      case '%':
        _onPercent();
        break;
      case '=':
        _onEquals();
        break;
      case '+':
      case '-':
      case '*':
      case '/':
        _onOperator(label);
        break;
      default:
        _onDigit(label);
    }
  }
}
