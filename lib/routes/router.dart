import 'package:aiocalculator/pages/Auth/login_page.dart';
import 'package:aiocalculator/pages/Auth/register_page.dart';
import 'package:aiocalculator/pages/calculator/backup.dart';
import 'package:aiocalculator/pages/calculator/basic_calculator.dart';
import 'package:aiocalculator/pages/calculator/convert_cryptocurrency.dart';
import 'package:aiocalculator/pages/calculator/convert_currency.dart';
import 'package:aiocalculator/pages/calculator/convert_timezone.dart';
import 'package:aiocalculator/pages/calculator/convert_unit.dart';
import 'package:aiocalculator/pages/calculator/download_time_calculator.dart';
import 'package:aiocalculator/pages/calculator/historyPage.dart';
import 'package:aiocalculator/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  // initialLocation: '/splash', // Set '/splash' as the initial location
  redirect: (context, state) async {
    final auth = FirebaseAuth.instance;

    // Allow register page to be accessible without login
    if (state.fullPath == '/register') {
      return null; // Do not redirect from the register page
    }

    // Redirect to login if not authenticated
    if (auth.currentUser == null && state.fullPath != '/login') {
      return '/login'; // Redirect to login if not authenticated
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'calculator',
          name: 'calculator',
          builder: (context, state) => const BasicCalculatorPage(),
        ),
        GoRoute(
          path: '/downloadtime-calculator',
          name: 'downloadTime',
          builder: (context, state) => const DownloadTimeCalculator(),
        ),
        GoRoute(
          path: '/unit-calculator',
          name: 'unitCalculator',
          builder: (context, state) => const UnitConversionPage(),
        ),
        GoRoute(
          path: '/currency-calculator',
          name: 'currencyCalculator',
          builder: (context, state) => const ConvertCurrency(),
        ),
        GoRoute(
          path: '/timezone',
          name: 'timezoneCalculator',
          builder: (context, state) => TimeZoneConverterPage(),
        ),
        GoRoute(
          path: '/crypto',
          name: 'crypto',
          builder: (context, state) => CryptoPricesPage(),
        ),
        GoRoute(
          path: '/downloadgagal',
          name: 'downloadgagal',
          builder: (context, state) => DownloadTimeCalculator2(),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) => HistoryPage(),
        ),

      ],
    ),
  ],
);
