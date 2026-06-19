import 'package:flutter/material.dart';
import 'boarding1.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key}); // Fixed parenthesis and added semicolon

  @override
  Widget build(BuildContext context) {
    // Removed duplicate MaterialApp to prevent routing issues
    return const TraveleraSplashScreen();
  }
} // Fixed closing bracket

class TraveleraSplashScreen extends StatelessWidget {
  const TraveleraSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // dynamic screen dimensions
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double logoSize = screenWidth * 0.45;
    final double taglineFontSize = screenHeight * 0.022;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingOneScreen(),
            ),
          );
        },
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                'assets/images/launching-bg.png',
                fit: BoxFit.cover,
              ),
            ),

            // Semi-transparent overlay
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.4),
              ),
            ),

            // Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),

                    // Logo
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