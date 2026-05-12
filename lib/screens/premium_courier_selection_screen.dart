import 'package:flutter/material.dart';
import '../widgets/courier_card.dart'; // ✅ INI DIPAKAI

class PremiumCourierSelectionScreen extends StatefulWidget {
  const PremiumCourierSelectionScreen({super.key});

  @override
  State<PremiumCourierSelectionScreen> createState() =>
      _PremiumCourierSelectionScreenState();
}

class _PremiumCourierSelectionScreenState
    extends State<PremiumCourierSelectionScreen> {
  String selectedCourier = 'sicepat'; // default favorit

  final List<Map<String, dynamic>> couriers = [
    {'name': 'J&T', 'code': 'jnt', 'icon': Icons.local_shipping, 'badge': 0},
    {'name': 'JNE', 'code': 'jne', 'icon': Icons.delivery_dining, 'badge': 0},
    {'name': 'SiCepat', 'code': 'sicepat', 'icon': Icons.flash_on, 'badge': 3},
    {'name': 'Pos ID', 'code': 'pos', 'icon': Icons.mail, 'badge': 0},
    {'name': 'TIKI', 'code': 'tiki', 'icon': Icons.inventory_2, 'badge': 2},
    {'name': 'Ninja', 'code': 'ninja', 'icon': Icons.rocket_launch, 'badge': 5},
    {'name': 'Lion', 'code': 'lion', 'icon': Icons.flight, 'badge': 0},
    {
      'name': 'Anteraja',
      'code': 'anteraja',
      'icon': Icons.local_shipping,
      'badge': 1
    },
  ];

  void _selectCourier(String code) {
    setState(() => selectedCourier = code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Pilih Kurir',
          style: TextStyle(
            color: Color(0xFF5C3317),
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF5C3317)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Layanan Pengiriman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C3317),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 GRID
            Expanded(
              child: GridView.builder(
                itemCount: couriers.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final c = couriers[index];

                  return CourierCard(
                    name: c['name'],
                    icon: c['icon'],
                    badge: c['badge'],
                    isSelected: selectedCourier == c['code'],
                    onTap: () => _selectCourier(c['code']),
                  );
                },
              ),
            ),

            // 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C3317),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Lanjutkan (${selectedCourier.toUpperCase()})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}