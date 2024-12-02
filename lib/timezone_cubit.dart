import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimeZoneState {
  final List<String> timeZones;
  final String fromTimeZone;
  final String toTimeZone;
  final String convertedTime;

  TimeZoneState({
    this.timeZones = const [],
    this.fromTimeZone = 'UTC',
    this.toTimeZone = 'Asia/Jakarta',
    this.convertedTime = '',
  });

  TimeZoneState copyWith({
    List<String>? timeZones,
    String? fromTimeZone,
    String? toTimeZone,
    String? convertedTime,
  }) {
    return TimeZoneState(
      timeZones: timeZones ?? this.timeZones,
      fromTimeZone: fromTimeZone ?? this.fromTimeZone,
      toTimeZone: toTimeZone ?? this.toTimeZone,
      convertedTime: convertedTime ?? this.convertedTime,
    );
  }
}
class TimeZoneCubit extends Cubit<TimeZoneState> {
  TimeZoneCubit() : super(TimeZoneState()) {
    fetchTimeZones();
  }

  Future<void> fetchTimeZones() async {
    try {
      final response = await http.get(Uri.parse('https://worldtimeapi.org/api/timezone'));
      if (response.statusCode == 200) {
        final timeZones = List<String>.from(json.decode(response.body));
        // Pastikan 'UTC' ada dalam daftar
        if (!timeZones.contains('UTC')) {
          timeZones.insert(0, 'UTC'); // Menambahkan UTC jika belum ada
        }
        emit(state.copyWith(timeZones: timeZones));
      }
    } catch (e) {
      print('Error fetching time zones: $e');
    }
  }

  Future<void> convertTime(String dateTime) async {
    try {
      final response = await http.get(
        Uri.parse('http://worldtimeapi.org/api/timezone/${state.toTimeZone}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(state.copyWith(convertedTime: data['datetime']));
      }
    } catch (e) {
      print('Error converting time: $e');
    }
  }

  void updateFromTimeZone(String timeZone) {
    emit(state.copyWith(fromTimeZone: timeZone));
  }

  void updateToTimeZone(String timeZone) {
    emit(state.copyWith(toTimeZone: timeZone));
  }
}
