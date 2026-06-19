import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'countries_screen.dart';
import 'about_us_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Generate screens array dynamically inside build to pass the function cleanly
    final List<Widget> screens = [
      HomeScreen(
        onGuideMeTapped: () {
          setState(() {
            _currentIndex = 1; // Switches tab index to Countries (1) reactively!
          });
        },
      ),
      const CountriesScreen(),
      const AboutUsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens, // Inject the updated screen array containing our callback logic
      ),
      bottomNavigationBar: Container(
        height: 75,
        color: const Color(0xFF89C7E7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', 0),
            _buildNavItem(Icons.public, 'Countries', 1),
            _buildNavItem(Icons.info_outline, 'AboutUs', 2),
            _buildNavItem(Icons.person_outline, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color activeColor = const Color(0xFF1E5D88);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? activeColor : Colors.black87,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
              color: isActive ? activeColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}