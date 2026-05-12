import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/staff_provider.dart';

class StaffIncomingScreen extends StatefulWidget {
  const StaffIncomingScreen({super.key});

  @override
  State<StaffIncomingScreen> createState() => _StaffIncomingScreenState();
}

class _StaffIncomingScreenState extends State<StaffIncomingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffProvider>().loadIncomingShipments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Shipment Masuk',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<StaffProvider>(
        builder: (context, provider, _) {
          final shipments = provider.incomingShipments;
          if (shipments.isEmpty) {
            return const Center(
              child: Text('Belum ada shipment masuk saat ini.',
                  textAlign: TextAlign.center),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: shipments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final shipment = shipments[index];
              return _ShipmentTile(shipment: shipment);
            },
          );
        },
      ),
    );
  }
}

class _ShipmentTile extends StatelessWidget {
  final shipment;

  const _ShipmentTile({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C3317),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    context.read<StaffProvider>().receiveShipment(shipment.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shipment diterima')));
                  },
                  child: const Text('Terima'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    context.read<StaffProvider>().markReadyToPack(shipment.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Shipment siap dipacking')));
                  },
                  child: const Text('Siap'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
