import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorCubit extends Cubit<String> {
  CalculatorCubit() : super('0');

  String _input = '';
  String _lastResult = '';

  final NumberFormat _formatter = NumberFormat.decimalPattern();

  void appendInput(String value) {
    if (value == '<') {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
      if (_input.isEmpty) {
        _input = '0';
      }
      emit(_formattedOutput(_input));
    } else if (value == '=') {
      try {
        final result = _evaluateExpression(_input.isEmpty ? _lastResult : _input);
        _lastResult = result;
        emit(_formattedOutput(result));
        _input = '';
      } catch (e) {
        emit('Error');
      }
    } else if (_isOperator(value)) {
      if (_input.isEmpty && _lastResult.isNotEmpty) {
        _input = _lastResult + value;
      } else if (_input.isNotEmpty && !_isOperator(_input[_input.length - 1])) {
        _input += value;
      }
      emit(_formattedOutput(_input));
    } else {
      if (_input == '0') {
        _input = value;
      } else {
        _input += value;
      }
      emit(_formattedOutput(_input));
    }
  }

  String _evaluateExpression(String expression) {
    try {
      final sanitizedExpression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser parser = Parser();
      Expression exp = parser.parse(sanitizedExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      return eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
    } catch (e) {
      return 'Error';
    }
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷';
  }

  String _formattedOutput(String value) {
    try {
      if (value == 'Error') return value;

      double? numericValue = double.tryParse(value);
      if (numericValue != null) {
        return _formatter.format(numericValue);
      }
      return value;
    } catch (e) {
      return value;
    }
  }
}
