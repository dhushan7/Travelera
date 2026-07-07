import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/aboutus-bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Translucent/Tint Overlay for Text Contrast
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.35), // Matches layout brightness tint
            ),
          ),

          // Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),

                    const SizedBox(height: 50),
                    // Main Intro Paragraph Block
                    const Text(
                      'Welcome to Travelera – your smart travel companion!\n\n'
                          'We’re more than just a tour guide app, '
                          'we’re your gateway to unforgettable journeys, '
                          'hidden gems, and authentic local experiences.\n\n'
                          'At Travelera, we believe that every trip '
                          'should be inspiring, easy, and personalized. '
                          'Whether you’re exploring bustling cities, '
                          'serene landscapes, or cultural landmarks, '
                          'our mission is to guide you every step of the way.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // "Why did you choose us?"  header
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Why did you choose us?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Bulleted Points List
                    _buildBulletPoint('Curated travel guides and handpicked tours'),
                    _buildBulletPoint('Real-time navigation and local insights'),
                    _buildBulletPoint('Easy booking with secure payments'),
                    _buildBulletPoint('Friendly, knowledgeable tour guides'),

                    SizedBox(height: screenHeight * 0.06),

                    //  Logo
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth * 0.35,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // padding
                    SizedBox(height: screenHeight * 0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reactive Single Bullet Item Custom Helper Component
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}