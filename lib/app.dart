import 'package:africmobile/screens/dashboardScreen.dart';
import 'package:africmobile/screens/loginScreen.dart';
import 'package:africmobile/screens/transactionsScreen.dart';
import 'package:africmobile/screens/transferScreen.dart';
import 'package:flutter/material.dart';

class AfricBankingApp extends StatelessWidget {
  const AfricBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '@Fric Banking',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF00BCD4),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00BCD4),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/transfer': (context) => const TransferScreen(),
        '/transactions': (context) => const TransactionsScreen(),
      },
    );
  }
}