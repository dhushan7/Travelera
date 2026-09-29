import 'package:flutter/material.dart';
import 'package_screen.dart';

class DestinationGridScreen extends StatelessWidget {
  final String countryName;
  final Color titleColor;
  final List<Map<String, String>> destinations;

  const DestinationGridScreen({
    super.key,
    required this.countryName,
    required this.titleColor,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, // Allows custom bottom nav container to hit base safely
        child: Column(
          children: [
            const SizedBox(height: 15),

            // Header with nested back button and logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 22),
                    onPressed: () {
                      Navigator.pop(context); // Pops back under nested Tab Navigator safely
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth * 0.32,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            // Country Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                countryName,
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: titleColor, // Custom header
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // GridView
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double cardWidth = (constraints.maxWidth - 16) / 2;
                        double cardHeight = cardWidth * 0.72; // Mimics aspect ratio

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(destinations.length, (index) {
                            final item = destinations[index];

                            // Handling odd item out at the end (Jaffna spans center or scales)
                            bool isLastOdd = index == destinations.length - 1 && destinations.length % 2 != 0;

                            return Container(
                              width: isLastOdd ? cardWidth : cardWidth,
                              margin: isLastOdd ? EdgeInsets.only(left: cardWidth / 2 + 4) : EdgeInsets.zero,
                              height: cardHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4), // Subtle rounding
                                image: DecorationImage(
                                  image: AssetImage(item['image']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Dark translucent layer to make text readable
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        item['name']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 4,
                                                color: Colors.black45,
                                                offset: Offset(1, 1),
                                              )
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),

                    const SizedBox(height: 35),

                    // Primary Action Button
                    SizedBox(
                      width: screenWidth * 0.58,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackageScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D5A8A), // Dark blue shade
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Start Journey',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, bool isActive, {bool isProfile = false}) {
    final color = isActive ? Colors.black87 : Colors.black54;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: isProfile ? 28 : 24),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: color,
              decoration: isActive ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ]
      ],
    );
  }
}