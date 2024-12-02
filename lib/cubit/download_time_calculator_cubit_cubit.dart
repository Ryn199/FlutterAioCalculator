import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'download_time_calculator_cubit_state.dart';

class DownloadTimeCalculatorCubitCubit extends Cubit<DownloadTimeCalculatorCubitState> {
  DownloadTimeCalculatorCubitCubit() : super(DownloadTimeCalculatorCubitInitial());
}
