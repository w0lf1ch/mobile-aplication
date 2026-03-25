import '../models/calculation.dart';
import '../services/firestore_service.dart';

class CalculatorController {
  final FirestoreService _firestoreService = FirestoreService.instance;

  String _currentInput = '';
  String _operator = '';
  double _firstOperand = 0;
  bool _shouldResetInput = false;

  String get currentInput => _currentInput.isEmpty ? '0' : _currentInput;

  void inputDigit(String digit) {
    if (_shouldResetInput) {
      _currentInput = '';
      _shouldResetInput = false;
    }

    if (digit == '.' && _currentInput.contains('.')) {
      return;
    }

    if (digit == '00' && _currentInput.isEmpty) {
      _currentInput = '0';
      return;
    }

    _currentInput += digit;
  }

  void inputOperator(String operator) {
    if (_currentInput.isEmpty || _currentInput == 'Error') {
      return;
    }

    _firstOperand = double.tryParse(_currentInput) ?? 0;
    _operator = operator;
    _shouldResetInput = true;
  }

  void applyPercent() {
    if (_currentInput.isEmpty || _currentInput == 'Error') {
      return;
    }

    final value = double.tryParse(_currentInput) ?? 0;
    final percentValue = value / 100;
    _currentInput = _formatNumber(percentValue);
  }

  Future<Calculation?> calculate() async {
    if (_operator.isEmpty || _currentInput.isEmpty || _currentInput == 'Error') {
      return null;
    }

    final secondOperand = double.tryParse(_currentInput) ?? 0;
    double resultValue;

    switch (_operator) {
      case '+':
        resultValue = _firstOperand + secondOperand;
        break;
      case '-':
        resultValue = _firstOperand - secondOperand;
        break;
      case '*':
        resultValue = _firstOperand * secondOperand;
        break;
      case '/':
        if (secondOperand == 0) {
          _currentInput = 'Error';
          _operator = '';
          _shouldResetInput = true;
          return null;
        }
        resultValue = _firstOperand / secondOperand;
        break;
      default:
        return null;
    }

    final resultText = _formatNumber(resultValue);
    final expression = '${_formatNumber(_firstOperand)} $_operator ${_formatNumber(secondOperand)}';

    final calculation = Calculation(
      expression: expression,
      result: resultText,
      timestamp: DateTime.now(),
    );

    await _firestoreService.addCalculation(calculation);

    _currentInput = resultText;
    _operator = '';
    _shouldResetInput = true;

    return calculation;
  }

  void clear() {
    _currentInput = '';
    _operator = '';
    _firstOperand = 0;
    _shouldResetInput = false;
  }

  void backspace() {
    if (_shouldResetInput || _currentInput.isEmpty || _currentInput == 'Error') {
      return;
    }

    _currentInput = _currentInput.substring(0, _currentInput.length - 1);
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value
        .toStringAsFixed(6)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
