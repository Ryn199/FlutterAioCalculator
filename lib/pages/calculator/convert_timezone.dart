import 'package:flutter/material.dart';

class TimeZoneConverterPage extends StatefulWidget {
  @override
  _TimeZoneConverterPageState createState() => _TimeZoneConverterPageState();
}

class _TimeZoneConverterPageState extends State<TimeZoneConverterPage> {
  TextEditingController _timeController = TextEditingController();
  String _selectedTimeZone = 'UTC';
  String _convertedTime = '';
  final List<String> _timeZones = ['UTC', 'GMT+1', 'GMT+5', 'GMT-3', 'GMT+9'];

  // Fungsi untuk mengonversi waktu
  void _convertTime() {
    // Ambil waktu yang dimasukkan oleh pengguna
    DateTime currentTime = DateTime.parse("2024-01-01 ${_timeController.text}:00");

    // Tentukan offset berdasarkan zona waktu yang dipilih
    int offset = _getOffsetForTimeZone(_selectedTimeZone);

    // Hitung waktu baru berdasarkan zona waktu yang dipilih
    DateTime convertedTime = currentTime.add(Duration(hours: offset));

    // Set hasil konversi ke dalam format string
    setState(() {
      _convertedTime = "${convertedTime.hour}:${convertedTime.minute.toString().padLeft(2, '0')}";
    });
  }

  // Fungsi untuk mendapatkan offset zona waktu
  int _getOffsetForTimeZone(String timeZone) {
    switch (timeZone) {
      case 'UTC':
        return 0; // UTC tidak ada offset
      case 'GMT+1':
        return 1;
      case 'GMT+5':
        return 5;
      case 'GMT-3':
        return -3;
      case 'GMT+9':
        return 9;
      default:
        return 0; // Default jika tidak ada yang cocok
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Zone Converter'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Masukkan waktu (jam:menit) [Contoh: 7:00]',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedTimeZone,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTimeZone = newValue!;
                });
              },
              items: _timeZones.map((String timeZone) {
                return DropdownMenuItem<String>(
                  value: timeZone,
                  child: Text(timeZone),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTime,
              child: Text('Konversi Waktu'),
            ),
            SizedBox(height: 20),
            Text(
              _convertedTime.isEmpty
                  ? 'Masukkan waktu dan pilih zona waktu.'
                  : 'Waktu di $_selectedTimeZone: $_convertedTime',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
