import 'package:aiocalculator/calculator_cubit.dart';
import 'package:aiocalculator/convert_currency_cubit.dart';
import 'package:aiocalculator/download_time_cubit.dart';
import 'package:aiocalculator/timezone_cubit.dart';
import 'package:aiocalculator/unitconversion_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aiocalculator/bloc/auth/auth_bloc.dart';
import 'package:aiocalculator/firebase_options.dart';
import 'package:aiocalculator/routes/router.dart';
import 'package:aiocalculator/visibility_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const AioCalculator());
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
}

class AioCalculator extends StatelessWidget {
  const AioCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VisibilityCubit>(
          create: (context) => VisibilityCubit(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<CalculatorCubit>(
          create: (context) => CalculatorCubit(),
        ),
        BlocProvider<DownloadTimeCubit>(
          create: (context) => DownloadTimeCubit(),
        ),
        BlocProvider<CurrencyCubit>(
          create: (context) => CurrencyCubit(),
        ),
        BlocProvider<TimeZoneCubit>(
          create: (context) => TimeZoneCubit(),
        ),
        BlocProvider<UnitConversionCubit>(
          create: (context) => UnitConversionCubit(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
