import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/staff_provider.dart';

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
              color: Colors.black.withOpacity(0.06),
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
                Text(
                    provider.isAvailable
                        ? 'Siap bekerja'
                        : 'Sedang tidak aktif',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: provider.isAvailable
                            ? Colors.green.shade700
                            : Colors.grey.shade700)),
                const SizedBox(height: 6),
                Text(
                    provider.isAvailable
                        ? 'Terima barang masuk dan update stok.'
                        : 'Aktifkan kembali untuk memproses.',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: provider.isAvailable
                  ? const Color(0xFF5C3317)
                  : Colors.green.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: provider.toggleAvailability,
            child: Text(provider.isAvailable ? 'Offline' : 'Online'),
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
              color: Colors.black.withOpacity(0.04),
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
              color: Colors.black.withOpacity(0.05),
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
