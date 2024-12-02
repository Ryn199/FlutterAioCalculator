import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'convert_currency_cubit_state.dart';

class ConvertCurrencyCubitCubit extends Cubit<ConvertCurrencyCubitState> {
  ConvertCurrencyCubitCubit() : super(ConvertCurrencyCubitInitial());
}
