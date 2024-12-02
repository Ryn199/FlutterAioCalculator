import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aiocalculator/bloc/auth/auth_bloc.dart';
import 'package:aiocalculator/visibility_cubit.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'LOGIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Memudahkan untuk Menghitung apapun',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                // Email Field
                TextFormField(
                  controller: emailC,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                BlocConsumer<VisibilityCubit, bool>(
                  listener: (context, state) {},
                  builder: (context, isObscured) {
                    return TextFormField(
                      controller: passC,
                      obscureText: isObscured,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            context.read<VisibilityCubit>().change();
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthEventLogin(
                        email: emailC.text,
                        password: passC.text,
                      ),
                    );
                  },
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthStateError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          duration: const Duration(seconds: 2),
                        ));
                      } else if (state is AuthStateLoaded) {
                        // Navigasi setelah login berhasil
                        context.go('/'); // Navigasi ke halaman utama setelah login
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthStateLoading) {
                        return const CircularProgressIndicator(color: Colors.white);
                      }
                      return const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Register Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(0, 121, 121, 121),
                  ),
                  onPressed: () {
                    debugPrint('Register Button Pressed');
                    context.go('/register'); // Arahkan ke halaman register
                  },
                  child: const Text(
                    'Belum punya akun? Register sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 95, 95, 95),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
