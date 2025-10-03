import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../shop_screan.dart';
import '../favorite_screen.dart';
import '../setting_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  void _navigateToScreen(BuildContext context, int index) {
    // Don't navigate if we're already on the current screen
    if (index == currentIndex) return;

    Widget targetScreen;
    
    switch (index) {
      case 0:
        targetScreen = const HomeScreen();
        break;
      case 1:
        targetScreen = const ShopScreen();
        break;
      case 2:
        targetScreen = const FavoritesScreen();
        break;
      case 3:
        targetScreen = const SettingsScreen();
        break;
      default:
        return;
    }

    // Navigate to the target screen and replace the current screen stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 6.0,
      height: 70,
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      // elevation:5,
      shadowColor: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Icon
          _buildNavItem(
            context: context,
            icon: Icons.home,
            index: 0,
            isActive: currentIndex == 0,
          ),
          
          // Shop Icon
          _buildNavItem(
            context: context,
            icon: Icons.shopping_cart,
            index: 1,
            isActive: currentIndex == 1,
          ),
          
          // Favorites Icon
          _buildNavItem(
            context: context,
            icon: Icons.favorite,
            index: 2,
            isActive: currentIndex == 2,
          ),
          
          // Settings Icon
          _buildNavItem(
            context: context,
            icon: Icons.settings,
            index: 3,
            isActive: currentIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required int index,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _navigateToScreen(context, index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? const Color.fromRGBO(240, 120, 40, 1) : const Color.fromARGB(255, 172, 168, 168),
                size: isActive ? 28 : 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}