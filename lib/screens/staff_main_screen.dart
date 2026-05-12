import 'package:flutter/material.dart';
import 'staff_dashboard_screen.dart';
import 'staff_incoming_screen.dart';
import 'staff_inventory_screen.dart';
import 'staff_profile_screen.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({super.key});

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    StaffDashboardScreen(),
    StaffIncomingScreen(),
    StaffInventoryScreen(),
    StaffProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, -4)),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF5C3317).withOpacity(0.12),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon:
                  Icon(Icons.dashboard_rounded, color: Color(0xFF5C3317)),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon:
                  Icon(Icons.inventory_2_rounded, color: Color(0xFF5C3317)),
              label: 'Masuk',
            ),
            NavigationDestination(
              icon: Icon(Icons.storage_outlined),
              selectedIcon:
                  Icon(Icons.storage_rounded, color: Color(0xFF5C3317)),
              label: 'Stok',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon:
                  Icon(Icons.person_rounded, color: Color(0xFF5C3317)),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
