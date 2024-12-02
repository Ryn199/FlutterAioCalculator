import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class UnitConversionCubit extends Cubit<UnitConversionState> {
  UnitConversionCubit() : super(UnitConversionInitial());

  // Fungsi untuk memilih kategori konversi
  void selectCategory(String category) {
    emit(UnitConversionCategorySelected(category: category));
  }

  // Fungsi untuk mengonversi satuan berdasarkan kategori dan nilai input
  void convert(String category, double value, String fromUnit, String toUnit) {
    double result = 0.0;

    // Kategori konversi
    if (category == 'Distance') {
      result = _convertDistance(value, fromUnit, toUnit);
    } else if (category == 'Weight') {
      result = _convertWeight(value, fromUnit, toUnit);
    }

    emit(UnitConversionResult(result: result));
  }

  // Konversi jarak
  double _convertDistance(double value, String fromUnit, String toUnit) {
    const distanceConversions = {
      'meter': 1.0,
      'centimeter': 100.0,
      'millimeter': 1000.0,
      'kilometer': 0.001,
      'mile': 0.000621371,
      'yard': 1.09361,
    };

    return value * (distanceConversions[toUnit]! / distanceConversions[fromUnit]!);
  }

  // Konversi berat
  double _convertWeight(double value, String fromUnit, String toUnit) {
    const weightConversions = {
      'gram': 1.0,
      'kilogram': 0.001,
      'milligram': 1000.0,
      'pound': 0.00220462,
      'ounce': 0.035274,
    };

    return value * (weightConversions[toUnit]! / weightConversions[fromUnit]!);
  }
}

abstract class UnitConversionState extends Equatable {
  const UnitConversionState();

  @override
  List<Object> get props => [];
}

class UnitConversionInitial extends UnitConversionState {}

class UnitConversionCategorySelected extends UnitConversionState {
  final String category;

  const UnitConversionCategorySelected({required this.category});

  @override
  List<Object> get props => [category];
}

class UnitConversionResult extends UnitConversionState {
  final double result;

  const UnitConversionResult({required this.result});

  @override
  List<Object> get props => [result];
}
