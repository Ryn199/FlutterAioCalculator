import 'package:flutter/material.dart';

class UnitConversionPage extends StatefulWidget {
  const UnitConversionPage({super.key});

  @override
  _UnitConversionPageState createState() => _UnitConversionPageState();
}

class _UnitConversionPageState extends State<UnitConversionPage> {
  final TextEditingController valueController = TextEditingController();

  String? kategori;
  String? dariSatuan;
  String? keSatuan;
  double inputValue = 0.0;
  double hasilKonversi = 0.0;

  final satuanJarak = ['meter', 'sentimeter', 'kilometer', 'mil', 'yard', 'inci'];
  final satuanBerat = ['gram', 'kilogram', 'pon', 'ons'];
  final satuanSuhu = ['Celsius', 'Fahrenheit', 'Kelvin'];
  final satuanWaktu = ['detik', 'menit', 'jam', 'hari'];

  // Fungsi untuk konversi nilai
  void convert() {
    double result = 0.0;

    // Konversi untuk kategori Jarak
    if (kategori == 'Jarak') {
      if (dariSatuan == 'meter' && keSatuan == 'sentimeter') {
        result = inputValue * 100;
      } else if (dariSatuan == 'meter' && keSatuan == 'kilometer') {
        result = inputValue / 1000;
      } else if (dariSatuan == 'sentimeter' && keSatuan == 'meter') {
        result = inputValue / 100;
      } else if (dariSatuan == 'kilometer' && keSatuan == 'meter') {
        result = inputValue * 1000;
      }
    }

    // Konversi untuk kategori Berat
    else if (kategori == 'Berat') {
      if (dariSatuan == 'gram' && keSatuan == 'kilogram') {
        result = inputValue / 1000;
      } else if (dariSatuan == 'kilogram' && keSatuan == 'gram') {
        result = inputValue * 1000;
      }
    }

    // Konversi untuk kategori Suhu
    else if (kategori == 'Suhu') {
      if (dariSatuan == 'Celsius' && keSatuan == 'Fahrenheit') {
        result = (inputValue * 9 / 5) + 32;
      } else if (dariSatuan == 'Celsius' && keSatuan == 'Kelvin') {
        result = inputValue + 273.15;
      } else if (dariSatuan == 'Fahrenheit' && keSatuan == 'Celsius') {
        result = (inputValue - 32) * 5 / 9;
      } else if (dariSatuan == 'Kelvin' && keSatuan == 'Celsius') {
        result = inputValue - 273.15;
      }
    }

    // Konversi untuk kategori Waktu
    else if (kategori == 'Waktu') {
      if (dariSatuan == 'detik' && keSatuan == 'menit') {
        result = inputValue / 60;
      } else if (dariSatuan == 'detik' && keSatuan == 'jam') {
        result = inputValue / 3600;
      } else if (dariSatuan == 'menit' && keSatuan == 'detik') {
        result = inputValue * 60;
      } else if (dariSatuan == 'jam' && keSatuan == 'detik') {
        result = inputValue * 3600;
      }
    }

    setState(() {
      hasilKonversi = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Konversi Satuan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown kategori
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    hint: const Text('Pilih Kategori'),
                    value: kategori,
                    isExpanded: true,
                    icon: const Icon(Icons.category),
                    items: const ['Jarak', 'Berat', 'Suhu', 'Waktu'].map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        kategori = value;
                        dariSatuan = null;
                        keSatuan = null;
                      });
                    },
                  ),
                ),
              ),

              // Input nilai
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Masukkan nilai',
                      prefixIcon: const Icon(Icons.input),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        inputValue = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
              ),

              // Dropdown satuan asal
              if (kategori != null) ...[
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      hint: const Text('Pilih Satuan Asal'),
                      value: dariSatuan,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_forward),
                      items: (kategori == 'Jarak'
                              ? satuanJarak
                              : kategori == 'Berat'
                                  ? satuanBerat
                                  : kategori == 'Suhu'
                                      ? satuanSuhu
                                      : satuanWaktu)
                          .map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dariSatuan = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Dropdown satuan tujuan
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      hint: const Text('Pilih Satuan Tujuan'),
                      value: keSatuan,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_back),
                      items: (kategori == 'Jarak'
                              ? satuanJarak
                              : kategori == 'Berat'
                                  ? satuanBerat
                                  : kategori == 'Suhu'
                                      ? satuanSuhu
                                      : satuanWaktu)
                          .map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          keSatuan = value;
                        });
                      },
                    ),
                  ),
                ),
              ],

              // Tombol konversi
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: dariSatuan != null && keSatuan != null && inputValue > 0.0
                        ? convert
                        : null,
                    child: const Text('Konversi'),
                  ),
                ),
              ),

              // Hasil konversi
              if (hasilKonversi != 0.0) ...[
                const SizedBox(height: 20),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hasil Konversi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hasil: ${hasilKonversi.toStringAsFixed(2)} $keSatuan',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

            ],
          ),
        ),
      ),
    );
  }
}