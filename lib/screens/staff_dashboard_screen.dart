import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/staff_provider.dart';
import 'staff_package_list_screen.dart';
import 'staff_scan_screen.dart';
import 'staff_warehouse_capacity_screen.dart';
import 'staff_incoming_screen.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffProvider>().loadDashboard();
      context.read<StaffProvider>().loadIncomingShipments();
      context.read<StaffProvider>().loadOverloadBatches();
      context.read<StaffProvider>().loadWarehouses();
      context.read<StaffProvider>().loadWarehousePackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title:
            const Text('Gudang', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<StaffProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(provider),
                const SizedBox(height: 18),
                _buildSummaryRow(provider),
                const SizedBox(height: 18),
                _buildActionRow(context, provider),
                const SizedBox(height: 12),
                _buildQuickLinks(context, provider),
                const SizedBox(height: 18),
                const Text('Shipment Masuk',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50))),
                const SizedBox(height: 12),
                ...provider.incomingShipments
                    .take(2)
                    .map((shipment) => _ShipmentCard(shipment: shipment))
                    .toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(StaffProvider provider) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status Gudang',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5C3317))),
                const SizedBox(height: 8),
                const Text('Siap bekerja',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32))),
                const SizedBox(height: 6),
                const Text('Terima barang masuk dan update stok.',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(StaffProvider provider) {
    return Row(
      children: [
        Expanded(
            child: _SummaryTile(
                title: 'Masuk', value: provider.shipmentCount.toString())),
        const SizedBox(width: 12),
        Expanded(
            child: _SummaryTile(
                title: 'Stok', value: provider.inventoryCount.toString())),
        const SizedBox(width: 12),
        Expanded(
            child: _SummaryTile(
                title: 'Stok Rendah',
                value: provider.lowStockCount.toString())),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context, StaffProvider provider) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaffIncomingScreen(),
                ),
              );
            },
            child: _buildActionCard(
              icon: Icons.list_alt_rounded,
              title: 'Tugas Aktif',
              subtitle: provider.incomingShipments.isNotEmpty
                  ? '${provider.incomingShipments.length} tugas aktif'
                  : 'Tidak ada tugas',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              final shipment = provider.incomingShipments.isNotEmpty
                  ? provider.incomingShipments.first
                  : null;
              if (shipment != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StaffScanScreen(shipment: shipment),
                  ),
                );
              }
            },
            child: _buildActionCard(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scan Paket',
              subtitle: provider.incomingShipments.isNotEmpty
                  ? 'Mulai scan paket masuk'
                  : 'Tidak ada shipment',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context, StaffProvider provider) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaffWarehouseCapacityScreen(),
                ),
              );
            },
            child: _buildActionCard(
              icon: Icons.warehouse_rounded,
              title: 'Kapasitas Gudang',
              subtitle: 'Cek kapasitas dan notifikasi',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaffPackageListScreen(),
                ),
              );
            },
            child: _buildActionCard(
              icon: Icons.inventory_2_rounded,
              title: 'Paket Gudang',
              subtitle: '${provider.warehousePackages.length} paket',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: const Color(0xFF5C3317)),
          const SizedBox(height: 14),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50))),
        ],
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  final shipment;

  const _ShipmentCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(shipment.resi,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xFF5C3317))),
              Text(shipment.status,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          Text('Pengirim: ${shipment.pengirim}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text('Tujuan: ${shipment.tujuan}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          Text('Masuk: ${shipment.tanggalMasuk}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
