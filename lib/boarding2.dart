import 'package:flutter/material.dart';
import 'boarding3.dart';

class OnboardingTwoScreen extends StatelessWidget {
  const OnboardingTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions dynamically for perfect scaling
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing definitions
    final double logoSize = screenWidth * 0.35; // Slightly smaller to give the grid room
    final double cardHeight = screenHeight * 0.38; // Height for the destination container layout
    final double descFontSize = screenHeight * 0.022;
    final double buttonHeight = screenHeight * 0.065;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Same Background Image as Onboarding 1
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding-bg2.png',
              fit: BoxFit.cover,
            ),
          ),

          // 3. Foreground Responsive Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                // Changed from spaceBetween to start to control vertical positioning from the top
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Precise Top Margin (40px equivalent)
                  const SizedBox(height: 40),

                  // 2. Logo Group (Now sitting firmly at the top)
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

                  // 3. Dynamic Spacer to push the rest of the content down
                  // This acts like a spring, pushing the text and button to the bottom area
                  const Spacer(),

                  // 4. Middle Content Panel (Grid or Description)
                  // (Insert your GridView container or onboarding text here)

                  const Spacer(), // Another flexible spacer to separate middle content from the button

                  // 5. Bottom Next Button
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
                              builder: (context) => const OnboardingThreeScreen(), // Replace with your actual class name in boarding1.dart
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
      alignment: Alignment.centerLeft, // Align category names cleanly over images
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