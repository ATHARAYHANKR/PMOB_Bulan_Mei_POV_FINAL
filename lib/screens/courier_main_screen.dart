import 'package:flutter/material.dart';
import 'courier_home_screen.dart';
import 'courier_orders_screen.dart';
import 'courier_history_screen.dart';
import 'courier_profile_screen.dart';

class CourierMainScreen extends StatefulWidget {
  const CourierMainScreen({super.key});

  @override
  State<CourierMainScreen> createState() => _CourierMainScreenState();
}

class _CourierMainScreenState extends State<CourierMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CourierHomeScreen(),
    CourierOrdersScreen(),
    CourierHistoryScreen(),
    CourierProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF5C3317).withOpacity(0.1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon:
                  Icon(Icons.dashboard_rounded, color: Color(0xFF5C3317)),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon:
                  Icon(Icons.list_alt_rounded, color: Color(0xFF5C3317)),
              label: 'Order',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon:
                  Icon(Icons.history_rounded, color: Color(0xFF5C3317)),
              label: 'Riwayat',
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
