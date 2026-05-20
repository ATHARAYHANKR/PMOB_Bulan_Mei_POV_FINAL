import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'package:provider/provider.dart';
import '../models/staff_model.dart';
import '../services/staff_provider.dart';
import 'staff_scan_screen.dart';

class StaffTaskDetailScreen extends StatelessWidget {
  final WarehouseShipment shipment;

  const StaffTaskDetailScreen({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Detail Tugas',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(shipment.resi,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(0xFF2C3E50))),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: shipment.status == 'Selesai'
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          shipment.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: shipment.status == 'Selesai'
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  _detailRow('Pengirim', shipment.pengirim),
                  const SizedBox(height: 10),
                  _detailRow('Tujuan', shipment.tujuan),
                  const SizedBox(height: 10),
                  _detailRow('Tanggal Masuk', shipment.tanggalMasuk),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Aksi Tugas',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF2C3E50))),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final finished = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StaffScanScreen(shipment: shipment),
                  ),
                );
                if (finished == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paket selesai diproses')),
                  );
                }
              },
              style: AppStyles.primaryButtonStyle().copyWith(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFF5C3317)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16)),
              ),
              child: const Text('Scan Paket',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            if (shipment.status != 'Selesai')
              ElevatedButton(
                onPressed: () async {
                  await context
                      .read<StaffProvider>()
                      .markReadyToPack(shipment.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shipment siap dipacking')),
                    );
                  }
                },
                style: AppStyles.primaryButtonStyle().copyWith(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.orange.shade700),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16)),
                ),
                child: const Text('Siap Packing',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50))),
        ),
      ],
    );
  }
}
