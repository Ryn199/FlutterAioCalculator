import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CurrencyState {
  final List<String> currencies;
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final double total;

  CurrencyState({
    this.currencies = const [],
    this.fromCurrency = 'IDR',
    this.toCurrency = 'USD',
    this.rate = 0.0,
    this.total = 0.0,
  });

  CurrencyState copyWith({
    List<String>? currencies,
    String? fromCurrency,
    String? toCurrency,
    double? rate,
    double? total,
  }) {
    return CurrencyState(
      currencies: currencies ?? this.currencies,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      total: total ?? this.total,
    );
  }
}

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(CurrencyState()) {
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    try {
      final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/IDR'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(state.copyWith(
          currencies: (data['rates'] as Map<String, dynamic>).keys.toList(),
          rate: data['rates'][state.toCurrency] ?? 0.0,
        ));
      }
    } catch (e) {
      print('Error fetching currencies: $e');
    }
  }

  Future<void> fetchRate() async {
    try {
      final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/${state.fromCurrency}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(state.copyWith(rate: data['rates'][state.toCurrency] ?? 0.0));
      }
    } catch (e) {
      print('Error fetching rate: $e');
    }
  }

  void swapCurrencies() {
    emit(state.copyWith(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
    ));
    fetchRate();
  }

  void updateAmount(String amount) {
    final total = (double.tryParse(amount) ?? 0) * state.rate;
    emit(state.copyWith(total: total));
  }

  void updateFromCurrency(String newCurrency) {
    emit(state.copyWith(fromCurrency: newCurrency));
    fetchRate();
  }

  void updateToCurrency(String newCurrency) {
    emit(state.copyWith(toCurrency: newCurrency));
    fetchRate();
  }
}
