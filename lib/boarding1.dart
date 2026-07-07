import 'package:flutter/material.dart';
import 'boarding2.dart';

class OnboardingOneScreen extends StatelessWidget {
  const OnboardingOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // dynamic screen dimensions
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive element calculations
    final double logoSize = screenWidth * 0.45;
    final double descFontSize = screenHeight * 0.022; // Dynamic text size (~18px)
    final double buttonHeight = screenHeight * 0.065; // Dynamic button height (~55px)

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding-bg1.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Generous side margins
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Spacer
                  SizedBox(height: screenHeight * 0.02),

                  // Center Logo
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: logoSize,
                          height: logoSize,
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

                  // Description Text
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Text(
                      'we turn your travel dreams into\ntailor-made experiences.\nPack your bags – the world is waiting,\nand your next escape starts here!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: descFontSize,
                        fontWeight: FontWeight.w700, // Bold text
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                        height: 1.4, // Increases line-spacing
                      ),
                    ),
                  ),

                  // Bottom Next Button
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: SizedBox(
                      width: double.infinity, // Full width button
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingTwoScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0082CD), // Vibrant blue
                          foregroundColor: Colors.white,
                          elevation: 0, // Flat design
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonHeight * 0.4), // rounded corners
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}