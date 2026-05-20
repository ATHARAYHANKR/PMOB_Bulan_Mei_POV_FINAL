import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import '../models/staff_model.dart';

class StaffScanCompleteScreen extends StatelessWidget {
  final WarehouseShipment shipment;

  const StaffScanCompleteScreen({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Scan Selesai',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF5C3317), size: 96),
            const SizedBox(height: 24),
            const Text('Paket Berhasil Diproses',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50))),
            const SizedBox(height: 16),
            Text('Resi ${shipment.resi} telah selesai diproses.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: AppStyles.primaryButtonStyle().copyWith(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFF5C3317)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
              ),
              child: const Text('Kembali ke Dashboard',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
