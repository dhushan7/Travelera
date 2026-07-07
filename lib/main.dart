import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'splash_screen.dart';

void main() async {
  // Flutter engine to verify background native channels exist before booting
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51TmSNaJ3CfUH9g1tExmPCPSbNJUKqtnqwvf5gS2zCS9cFKNPkR5n1EeAtmHmhG2IpuqeeSgAHWXIIyTANh0ipEbM005C8DIlMl";

  // Starts up cloud data architecture parameters
  await Firebase.initializeApp();
  // await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travelera',
      home: SplashScreen(),
    );
  }
}