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

  // Global keys to keep track of each tab's independent navigation state
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home Navigation Key
    GlobalKey<NavigatorState>(), // Countries Navigation Key
    GlobalKey<NavigatorState>(), // AboutUs Navigation Key
    GlobalKey<NavigatorState>(), // Profile Navigation Key
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WillPopScope ensures that the Android system back button pops the internal
      // tab history instead of closing the entire application abruptly.
      body: WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
          !await _navigatorKeys[_currentIndex].currentState!.maybePop();
          return isFirstRouteInCurrentTab;
        },
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(0, HomeScreen(onGuideMeTapped: () => setState(() => _currentIndex = 1))),
            _buildTabNavigator(1, const CountriesScreen()),
            _buildTabNavigator(2, const AboutUsScreen()),
            _buildTabNavigator(3, const ProfileScreen()),
          ],
        ),
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

  // wraps every primary tab view inside its own nested Navigator
  Widget _buildTabNavigator(int index, Widget rootPage) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => rootPage,
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color activeColor = const Color(0xFF1E5D88);

    return GestureDetector(
      onTap: () {
        if (_currentIndex == index) {
          // If the user taps the already active tab icon, pop it all the way back to its root
          _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: isActive ? activeColor : Colors.black87),
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