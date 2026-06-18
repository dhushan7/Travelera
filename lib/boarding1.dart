import 'package:flutter/material.dart';
import 'boarding2.dart';

class OnboardingOneScreen extends StatelessWidget {
  const OnboardingOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions dynamically for perfect scaling
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive element calculations
    final double logoSize = screenWidth * 0.45;
    final double descFontSize = screenHeight * 0.022; // Dynamic text size (~18px)
    final double buttonHeight = screenHeight * 0.065; // Dynamic button height (~55px)

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding-bg1.png', // Update with your new background filename
              fit: BoxFit.cover,
            ),
          ),

          // 2. Foreground Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Generous side margins
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Spacer
                  SizedBox(height: screenHeight * 0.02),

                  // Center Logo Group
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

                  // Middle Description Text
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Text(
                      'we turn your travel dreams into\ntailor-made experiences.\nPack your bags – the world is waiting,\nand your next escape starts here!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: descFontSize,
                        fontWeight: FontWeight.w700, // Bold emphasis matching the design
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                        height: 1.4, // Increases line-spacing for better readability
                      ),
                    ),
                  ),

                  // Bottom Next Button
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: SizedBox(
                      width: double.infinity, // Full width button relative to padding
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingTwoScreen(), // Replace with your actual class name in boarding1.dart
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0082CD), // Vibrant blue matching the screenshot
                          foregroundColor: Colors.white,
                          elevation: 0, // Flat design
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonHeight * 0.4), // Perfectly rounded corners
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