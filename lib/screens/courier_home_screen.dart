import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/courier_provider.dart';
import '../models/courier_delivery_model.dart';
import 'courier_delivery_detail_screen.dart';

class CourierHomeScreen extends StatefulWidget {
  const CourierHomeScreen({super.key});

  @override
  State<CourierHomeScreen> createState() => _CourierHomeScreenState();
}

class _CourierHomeScreenState extends State<CourierHomeScreen> {
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourierProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Consumer<CourierProvider>(
        builder: (context, provider, _) {
          final activeOrders = provider.activeOrders;
          final pickupOrders = activeOrders
              .where((order) => order.status.toLowerCase().contains('pickup'))
              .toList();
          final deliveryOrders = activeOrders
              .where((order) => order.status.toLowerCase().contains('deliv'))
              .toList();
          final filteredOrders = _selectedFilter == 1
              ? pickupOrders
              : _selectedFilter == 2
                  ? deliveryOrders
                  : activeOrders;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider),
                  const SizedBox(height: 18),
                  _buildSummaryGrid(activeOrders.length, pickupOrders.length,
                      deliveryOrders.length, provider.history.length),
                  const SizedBox(height: 20),
                  _buildFilterSection(activeOrders.length, pickupOrders.length,
                      deliveryOrders.length),
                  const SizedBox(height: 18),
                  ..._buildTaskSection(filteredOrders),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(CourierProvider provider) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C3317).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person, color: Color(0xFF5C3317)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Halo, Huda Amirul',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2C3E50))),
                        SizedBox(height: 4),
                        Text('Kurir Aktif',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5C3317),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: Color(0xFF5C3317), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      provider.isOnline
                          ? 'Lokasi aktif, siap menjalankan pengiriman.'
                          : 'Lokasi tidak aktif. Hidupkan status untuk menerima tugas.',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF5C3317)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid(int total, int pickup, int delivery, int selesai) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SummaryTile(
                title: 'Total Tugas',
                value: total.toString(),
                icon: Icons.task_alt_rounded,
                color: const Color(0xFF5C3317)),
            const SizedBox(width: 12),
            _SummaryTile(
                title: 'Pickup',
                value: pickup.toString(),
                icon: Icons.archive_rounded,
                color: const Color(0xFFFF6B00)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _SummaryTile(
                title: 'Delivery',
                value: delivery.toString(),
                icon: Icons.local_shipping_rounded,
                color: const Color(0xFF3568A1)),
            const SizedBox(width: 12),
            _SummaryTile(
                title: 'Selesai',
                value: selesai.toString(),
                icon: Icons.check_circle_rounded,
                color: const Color(0xFF2E7D32)),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterSection(int total, int pickup, int delivery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tugas Hari Ini',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50))),
        const SizedBox(height: 14),
        Row(
          children: [
            _FilterChip(
              label: 'Semua',
              count: total,
              selected: _selectedFilter == 0,
              onTap: () => setState(() => _selectedFilter = 0),
            ),
            const SizedBox(width: 10),
            _FilterChip(
              label: 'Pickup',
              count: pickup,
              selected: _selectedFilter == 1,
              onTap: () => setState(() => _selectedFilter = 1),
            ),
            const SizedBox(width: 10),
            _FilterChip(
              label: 'Delivery',
              count: delivery,
              selected: _selectedFilter == 2,
              onTap: () => setState(() => _selectedFilter = 2),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildTaskSection(List<CourierDelivery> orders) {
    if (orders.isEmpty) {
      return [
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'Tidak ada tugas pada kategori ini.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ];
    }

    return [
      const SizedBox(height: 18),
      Column(
        children: orders.map((order) => _OrderCard(order: order)).toList(),
      ),
    ];
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryTile(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey, height: 1.3)),
                  const SizedBox(height: 6),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C3E50))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label,
      required this.count,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF5C3317) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color:
                    selected ? const Color(0xFF5C3317) : Colors.grey.shade300),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: const Color(0xFF5C3317).withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$label ($count)',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          selected ? Colors.white : const Color(0xFF2C3E50))),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final CourierDelivery order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CourierDeliveryDetailScreen(order: order)),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.ekspedisi,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF5C3317))),
            const SizedBox(height: 8),
            Text(order.nomorResi,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(order.alamatAntar,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey))),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C3317).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(order.status,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5C3317))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
