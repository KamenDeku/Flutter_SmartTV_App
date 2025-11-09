import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TvGamingApp());
}

class TvGamingApp extends StatelessWidget {
  const TvGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GamerZone Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF141414),
      ),
      home: const HomeScreen(), // Pantalla inicial
    );
  }
}
