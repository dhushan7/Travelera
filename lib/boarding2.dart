import 'package:flutter/material.dart';
import 'boarding3.dart';

class OnboardingTwoScreen extends StatelessWidget {
  const OnboardingTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // dynamic screen dimensions
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final double logoSize = screenWidth * 0.35;
    final double cardHeight = screenHeight * 0.38;
    final double descFontSize = screenHeight * 0.022;
    final double buttonHeight = screenHeight * 0.065;

    return Scaffold(
      body: Stack(
        children: [
          //  Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding-bg2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Margin (40px equivalent)
                  const SizedBox(height: 40),

                  // Logo
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
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

                  // Dynamic Spacer to push the rest of the content down
                  // This acts like a spring, pushing the text and button to the bottom area
                  const Spacer(),

                  // Next Button
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingThreeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0082CD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonHeight * 0.4),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w900),
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

  // Helper builder widget to create uniform individual destination grid cells quickly
  Widget _buildGridItem(String title, String assetPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.15), // Dim image slightly to make text pop clearly
            BlendMode.darken,
          ),
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          shadows: [
            Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(1, 1)),
          ],
        ),
      ),
    );
  }
}