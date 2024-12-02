import 'package:bloc/bloc.dart';

class DownloadTimeCubit extends Cubit<String> {
  // Inisialisasi dengan nilai default
  DownloadTimeCubit() : super('Enter values to calculate time'); // Nilai default saat pertama kali

  void calculateDownloadTime(double speed, double size) {
    final downloadTime = (size * 1024) / (speed * 0.125); // Menghitung waktu download
    final duration = Duration(seconds: downloadTime.round());
    
    // Format waktu menjadi HH:MM:SS
    final formattedTime = '${duration.inHours} Jam. ${duration.inMinutes % 60} Menit. ${duration.inSeconds % 60} Detik';
    
    // Emit state baru
    emit(formattedTime);
  }

  void resetState() {
    emit('Enter values to calculate time');  // Reset ke state default
  }
}
