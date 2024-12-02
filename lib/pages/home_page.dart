import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The home screen
class HomePage extends StatelessWidget {
  /// Constructs a [HomePage]
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> calculators = [
      {
        'title': 'Basic Calculator',
        'image': 'https://i.pinimg.com/736x/ed/c9/c8/edc9c890f6d0b615bcbe698b698fd05d.jpg',
        'route': '/calculator',
      },
      {
        'title': 'Unit Converter',
        'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDey4JDHrHrSUHtJ9m7AHkq-VgtyUKk6RuqQ&s',
        'route': '/unit-calculator',
      },
      {
        'title': 'Download Time Calculator',
        'image': 'https://i.pinimg.com/736x/89/dd/00/89dd00c50978559200934d1db5769ad9.jpg',
        'route': '/downloadtime-calculator',
      },
      {
        'title': 'Konversi Mata Uang',
        'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNEpwFdoqjB2hMUz2aO36Idy_TsPFWi9jWuw&s',
        'route': '/currency-calculator',
      },
      {
        'title': 'Konversi Mata Uang ke Crypto',
        'image': 'https://i.pinimg.com/736x/62/0d/4e/620d4ea55fced343fe99b46cd2091ebc.jpg',
        'route': '/crypto',
      },
      {
        'title': 'Konversi Zona Waktu',
        'image': 'https://i.pinimg.com/736x/a3/5c/ea/a35cea0a5b7002153a2251eb14394b7b.jpg',
        'route': '/timezone',
      },
      {
        'title': 'Test',
        'image': 'https://via.placeholder.com/400x200?text=Mata+Uang+Calculator',
        'route': '/downloadgagal',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AIO Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.goNamed('login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: calculators.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final calculator = calculators[index];
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () => context.go(calculator['route']!),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        calculator['image']!,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 40, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          calculator['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
