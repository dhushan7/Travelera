import 'package:flutter/material.dart';
import 'booking_payment_screen.dart';

class PackageScreen extends StatelessWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, String>> requirements = [
      {
        'title': 'Couple',
        'subtitle': '',
        'image': 'assets/images/couple_bg.png',
      },
      {
        'title': 'Family',
        'subtitle': '(2-7 persons, included 1-5 child)',
        'image': 'assets/images/family_bg.png',
      },
      {
        'title': 'Family Plus',
        'subtitle': '(4-15 persons, included 2-11 child)',
        'image': 'assets/images/family_plus_bg.png',
      },
      {
        'title': 'Group',
        'subtitle': '(10-25 persons)',
        'image': 'assets/images/group_bg.png',
      },
      {
        'title': 'Enhanced Group',
        'subtitle': '(15-50 persons)',
        'image': 'assets/images/enhanced_group_bg.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
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

            // Page Title Header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Select Your Requirement...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF004B87),
                ),
              ),
            ),

            // Scrollable List Body Container
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: requirements.length,
                itemBuilder: (context, index) {
                  final item = requirements[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Container(
                      height: screenHeight * 0.14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.white.withOpacity(0.45),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Drop onto the dynamic booking payment sheet layout safely
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingPaymentScreen(
                                          requirementTitle: item['title']!,
                                          imagePath: item['image']!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item['title']!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 32,
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          if (item['subtitle']!.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              item['subtitle']!,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
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