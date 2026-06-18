import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track active tab index for the bottom navigation bar
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double logoSize = screenWidth * 0.35;
    final double bannerHeight = screenHeight * 0.22;
    final double bannerWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  Top Margin for Logo (40px)
            const SizedBox(height: 40),

            // Branded Logo
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

            // Act like a spring to balance spacing
            const Spacer(),

            // Banner Image
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Container(
                width: bannerWidth,
                height: bannerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/home-banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Invitation Typography Block
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: const Text(
                'For your enjoyable journey\nWe are here to\nGuide You...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ),

            const Spacer(),

            // "Guide me" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: screenWidth * 0.65,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // next country window
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5D88), // Deep slate blue
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Guide me',
                    style: TextStyle(
                      fontSize: 32, // Large bold title label
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),

            // space between nav bar and content
            const Spacer(flex: 2),
          ],
        ),
      ),

      // Bottom Navigation Bar Layout
      bottomNavigationBar: Container(
        height: 75,
        color: const Color(0xFF89C7E7), // Light blue
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', 0),
            _buildNavItem(Icons.person_outline, 'Profile', 1),
            _buildNavItem(Icons.public, 'Countries', 2),
            _buildNavItem(Icons.info_outline, 'AboutUs', 3),
          ],
        ),
      ),
    );
  }

  // Custom Navigation Item Builder
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? const Color(0xFF1E5D88) : Colors.black87, // Highlighting selection state
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
              color: isActive ? const Color(0xFF1E5D88) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}