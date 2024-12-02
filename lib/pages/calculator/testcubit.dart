import 'package:aiocalculator/convert_currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertCurrencyPage extends StatelessWidget {
  const ConvertCurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrencyCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 209, 209, 209),
          elevation: 0,
          foregroundColor: Colors.black,
          title: const Text("Konversi Mata Uang"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Image.asset(
                    'images/test.jpg',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
                BlocBuilder<CurrencyCubit, CurrencyState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Nominal',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            context.read<CurrencyCubit>().updateAmount(value);
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              value: state.fromCurrency,
                              items: state.currencies.map((currency) {
                                return DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                );
                              }).toList(),
                              onChanged: (value) {
                                context.read<CurrencyCubit>().updateFromCurrency(value!);
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<CurrencyCubit>().swapCurrencies();
                              },
                              icon: const Icon(Icons.swap_horiz, size: 40, color: Colors.black),
                            ),
                            DropdownButton<String>(
                              value: state.toCurrency,
                              items: state.currencies.map((currency) {
                                return DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                );
                              }).toList(),
                              onChanged: (value) {
                                context.read<CurrencyCubit>().updateToCurrency(value!);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Rate: ${state.rate.toStringAsFixed(3)}',
                          style: const TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Total: ${state.total.toStringAsFixed(3)}',
                          style: const TextStyle(fontSize: 40, color: Colors.green),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
