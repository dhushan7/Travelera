import 'package:flutter/material.dart';

class CountriesScreen extends StatelessWidget {
  const CountriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Mock data structures pointing directly to layout layers
    final List<Map<String, String>> countryData = [
      {
        'name': 'Sri Lanka',
        'bgImage': 'assets/images/srilanka_bg.png',
        'fgImage': 'assets/images/srilanka_fg.png'
      },
      {
        'name': 'Dubai',
        'bgImage': 'assets/images/dubai_bg.png',
        'fgImage': 'assets/images/dubai_fg.png'
      },
      {
        'name': 'Singapore',
        'bgImage': 'assets/images/singapore_bg.png',
        'fgImage': 'assets/images/singapore_fg.png'
      },
      {
        'name': 'Malaysia',
        'bgImage': 'assets/images/malaysia_bg.png',
        'fgImage': 'assets/images/malaysia_fg.png'
      },
      {
        'name': 'Japan',
        'bgImage': 'assets/images/japan_bg.png',
        'fgImage': 'assets/images/japan_fg.png'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: screenWidth * 0.32,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            // Scrollable Content Region
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                itemCount: countryData.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final country = countryData[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      height: screenHeight * 0.18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Background Image
                            Positioned.fill(
                              child: Image.asset(
                                country['bgImage']!,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Translucent Gray overlay layer
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.12),
                              ),
                            ),

                            // Foreground Layout
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 14.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Country Names
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          country['name']!,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF222222),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Foreground Frame
                                    Container(
                                      width: screenWidth * 0.36,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: AssetImage(country['fgImage']!),
                                          fit: BoxFit.cover,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}