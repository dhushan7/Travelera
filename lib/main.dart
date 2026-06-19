import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'welcome_page.dart'; // Imports your newly separated layout page file

void main() async {
  // 1. Tells the Flutter engine to verify background native channels exist before booting
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Starts up cloud data architecture parameters
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travelera',
      home: WelcomeScreen(), // Boots your isolated welcome page layout right away
    );
  }
}