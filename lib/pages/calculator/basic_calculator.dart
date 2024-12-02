import 'package:aiocalculator/calculator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicCalculatorPage extends StatelessWidget {
  const BasicCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculatorCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Basic Calculator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: BlocBuilder<CalculatorCubit, String>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Display
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Buttons
                Column(
                  children: [
                    _buildButtonRow(context, ['1', '2', '3', '-']),
                    _buildButtonRow(context, ['4', '5', '6', '×']),
                    _buildButtonRow(context, ['7', '8', '9', '÷']),
                    _buildButtonRow(context, ['<', '0', '=', '+']),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Function to build rows of buttons
  Widget _buildButtonRow(BuildContext context, List<String> buttons) {
    return Row(
      children: buttons.map((buttonText) => _buildButton(context, buttonText)).toList(),
    );
  }

  // Function to build individual button
  Widget _buildButton(BuildContext context, String buttonText) {
    final buttonColor = _getButtonColor(buttonText);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            // Access the Cubit and send the button value
            context.read<CalculatorCubit>().appendInput(buttonText);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Utility function to determine button color
  Color _getButtonColor(String buttonText) {
    if (buttonText == 'C') return Colors.red;
    if (buttonText == '=') return Colors.green;
    if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
      return const Color.fromARGB(255, 255, 128, 9);
    }
    return const Color.fromARGB(255, 21, 120, 202);
  }
}
