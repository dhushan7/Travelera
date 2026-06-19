import 'package:flutter/material.dart';
import 'home_screen.dart';
// import 'screens/profile_screen.dart';
// import 'screens/countries_screen.dart';
// import 'screens/about_us_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Array stack holding active internal pages
  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Countries Screen', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
    const Center(child: Text('About Us Screen', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
    const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves the scroll position and state of each tab cleanly
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 75,
        color: const Color(0xFF89C7E7), // Light blue
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

  // Custom Navigation Item Builder
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color activeColor = const Color(0xFF1E5D88); // Deep slate blue

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index; // Updates stack viewing position pipeline
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