import 'package:flutter/material.dart';
import 'boarding1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TraveleraSplashScreen(),
    );
  }
}

class TraveleraSplashScreen extends StatelessWidget {
  const TraveleraSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions dynamically
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive sizes based on percentages of the viewport
    final double logoSize = screenWidth * 0.45;
    final double taglineFontSize = screenHeight * 0.022;

    return Scaffold(
      // Wrapped the entire stack in a GestureDetector to capture taps anywhere
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures taps are registered even on transparent/empty areas
        onTap: () {
          // Navigates to OnboardingOneScreen and removes the splash screen from the backstack
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingOneScreen(), // Replace with your actual class name in boarding1.dart
            ),
          );
        },
        child: Stack(
          children: [
            // 1. Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/launching-bg.png',
                fit: BoxFit.cover,
              ),
            ),

            // 2. Semi-transparent overlay
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.4),
              ),
            ),

            // 3. Foreground Responsive Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top spacer responsive to screen height
                    SizedBox(height: screenHeight * 0.05),

                    // Center Branding Group
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: logoSize * 1.5,
                            height: logoSize * 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(logoSize * 0.22),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Bottom Tagline
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                      child: Text(
                        'Every journey begins with a dream...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: taglineFontSize,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}