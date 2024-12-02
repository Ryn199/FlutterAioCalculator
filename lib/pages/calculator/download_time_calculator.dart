import 'package:aiocalculator/download_time_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadTimeCalculator extends StatelessWidget {
  const DownloadTimeCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController speedController = TextEditingController();
    final TextEditingController sizeController = TextEditingController();

    // Pastikan reset state saat halaman pertama kali dibuka
    Future.delayed(Duration.zero, () {
      context.read<DownloadTimeCubit>().resetState();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Time Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: speedController,
              decoration: const InputDecoration(
                labelText: 'Speed (Mbps)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: sizeController,
              decoration: const InputDecoration(
                labelText: 'File Size (GB)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final speed = double.tryParse(speedController.text);
                final size = double.tryParse(sizeController.text);

                if (speed == null || size == null || speed <= 0 || size <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid input. Enter positive numbers.')),
                  );
                  return;
                }

                print('Calculating download time...');
                context.read<DownloadTimeCubit>().calculateDownloadTime(
                      speed,
                      size,
                    );
              },
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 32),
            BlocBuilder<DownloadTimeCubit, String>(
              builder: (context, state) {
                print('Builder triggered with state: $state');
                return Text(
                  state.isEmpty ? 'Masukkan Speed dan Ukuran File untuk melihat waktu download' : state,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
