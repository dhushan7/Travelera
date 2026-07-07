import 'package:flutter/material.dart';
import 'signup_screen.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive element
    final double cardWidth = screenWidth * 0.88;
    final double logoSize = screenWidth * 0.32;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/terms-bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Components
          SafeArea(
            child: Stack(
              children: [
                // Content Card
                Positioned(
                  top: 80,
                  left: 25,
                  right: 25,
                  child: Container(
                    width: cardWidth,
                    // Dynamic constraint
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.70,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 26.0),
                    decoration: BoxDecoration(
                      // grey/white mix
                      color: const Color(0xffd8d8d8).withOpacity(0.65),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Card Heading
                          const Text(
                            'Terms and Conditons:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),

                          //  Body Text block
                          const Text(
                            '\nBy using TRAVELERA, you agree to our terms of service.\n\n\n'
                                'Users must be 18+ and responsible for keeping their account '
                                'details safe. The app allows booking tours, communicating with '
                                'guides, and leaving reviews.\n'
                                'Payments, cancellations, and refunds are subject to our policy. '
                                'Tour guides must provide accurate information and follow local laws.\n'
                                'We are not liable for user interactions, missed tours, or third-party issues. '
                                'All content and branding belong to us. Misuse of the app may result in suspension.\n'
                                'By continuing to use the app, you accept any updates to these terms.\n'
                                'For full details, please refer to our complete Terms & Conditions and Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // routing back to Signup
                          GestureDetector(
                            onTap: () {
                              // go back to the Sign-up screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Back to Sign up',
                              style: TextStyle(
                                color: Color(0xFF00529B),
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),

                // Logo
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: screenHeight * 0.07,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: logoSize * 1.2,
                        height: logoSize * 1.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(logoSize * 0.22),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}