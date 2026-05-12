import 'package:flutter/material.dart';
import 'courier_card.dart';

class PremiumExpedisiGrid extends StatefulWidget {
  final Function(String) onCourierSelected;
  final String selectedCourier;

  const PremiumExpedisiGrid({
    super.key,
    required this.onCourierSelected,
    this.selectedCourier = '',
  });

  @override
  State<PremiumExpedisiGrid> createState() => _PremiumExpedisiGridState();
}

class _PremiumExpedisiGridState extends State<PremiumExpedisiGrid> {
  // Courier data with icons
  final List<Map<String, dynamic>> couriers = [
    {
      'name': 'J&T',
      'code': 'jnt',
      'icon': Icons.local_shipping_outlined,
      'badge': 0,
    },
    {
      'name': 'JNE',
      'code': 'jne',
      'icon': Icons.delivery_dining_outlined,
      'badge': 0,
    },
    {
      'name': 'SiCepat',
      'code': 'sicepat',
      'icon': Icons.speed,
      'badge': 3,
    },
    {
      'name': 'Pos ID',
      'code': 'pos',
      'icon': Icons.mail_outline,
      'badge': 0,
    },
    {
      'name': 'TIKI',
      'code': 'tiki',
      'icon': Icons.local_shipping_outlined,
      'badge': 0,
    },
    {
      'name': 'Ninja',
      'code': 'ninja',
      'icon': Icons.rocket_launch_outlined,
      'badge': 5,
    },
    {
      'name': 'Lion',
      'code': 'lion',
      'icon': Icons.local_shipping_outlined,
      'badge': 0,
    },
    {
      'name': 'Anteraja',
      'code': 'anteraja',
      'icon': Icons.directions_car_outlined,
      'badge': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Kurir Pengiriman',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5C3317),
                  ),
            ),
            const SizedBox(height: 16),
            // Premium GridView with 4 columns
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 14,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: couriers.length,
              itemBuilder: (context, index) {
                final courier = couriers[index];
                final isSelected = widget.selectedCourier == courier['code'];

                return CourierCard(
                  name: courier['name'] ?? 'Unknown',
                  icon: courier['icon'] ?? Icons.local_shipping_outlined,
                  badge: courier['badge'] ?? 0,
                  isSelected: isSelected,
                  onTap: () {
                    widget.onCourierSelected(courier['code']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${courier['name']} dipilih'),
                        duration: const Duration(milliseconds: 800),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF5C3317),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
