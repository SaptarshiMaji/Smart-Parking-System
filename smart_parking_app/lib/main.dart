import 'package:flutter/material.dart';

import 'constants/app_theme.dart';

import 'screens/splash_screen.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Smart Parking',

      theme: AppTheme.darkTheme,

      home: const SplashScreen(),
    );
  }
}