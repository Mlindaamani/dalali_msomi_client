import 'package:fixy/screen/profiles/owner/profile_screen.dart';
import 'package:fixy/screen/property/property_form_screen.dart';
import 'package:fixy/screen/property/property_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GoogleBottomNavBar extends StatefulWidget {
  const GoogleBottomNavBar({super.key});

  @override
  State<GoogleBottomNavBar> createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleBottomNavBar> {
  int selectedIndex = 0;

  final List<Widget> _screens = const [
    PropertyListScreen(),
    SellDalaliMsomiProperty(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);
    const accentColor = Colors.indigoAccent;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: _screens[selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              setState(() => selectedIndex = index);
            },
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.white,
            tabBackgroundColor: accentColor.withOpacity(0.1),
            color: Colors.grey.shade600,
            activeColor: primaryColor,
            iconSize: 24,
            tabs: const [
              GButton(icon: Icons.home_outlined, text: 'Home'),
              GButton(icon: Icons.add_outlined, text: 'Sell'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
