import 'package:flutter/material.dart';
import 'package:flutter_taxi_fare_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    FlutterTaxiFareApp(),
  );
}

class FlutterTaxiFareApp extends StatefulWidget {
  const FlutterTaxiFareApp({super.key});

  @override
  State<FlutterTaxiFareApp> createState() => _FlutterTaxiFareAppState();
}

class _FlutterTaxiFareAppState extends State<FlutterTaxiFareApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}