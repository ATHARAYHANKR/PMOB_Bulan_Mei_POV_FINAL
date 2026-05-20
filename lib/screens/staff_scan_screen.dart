import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'package:provider/provider.dart';
import '../models/staff_model.dart';
import '../services/staff_provider.dart';
import 'staff_scan_complete_screen.dart';

class StaffScanScreen extends StatefulWidget {
  final WarehouseShipment shipment;

  const StaffScanScreen({super.key, required this.shipment});

  @override
  State<StaffScanScreen> createState() => _StaffScanScreenState();
}

class _StaffScanScreenState extends State<StaffScanScreen> {
  bool _isScanning = false;
  bool _success = false;

  Future<void> _startScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isScanning = false;
      _success = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Scan Paket',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _success
                      ? const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF5C3317), size: 92)
                      : const Icon(Icons.qr_code_scanner_rounded,
                          color: Color(0xFF5C3317), size: 92),
                  const SizedBox(height: 24),
                  Text(
                    _success
                        ? 'Hasil Deteksi Sistem'
                        : 'Arahkan kamera ke resi',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _success
                        ? widget.shipment.resi
                        : 'Pastikan resi terlihat jelas di kamera.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (!_success) ...[
              ElevatedButton(
                onPressed: _isScanning ? null : _startScan,
                style: AppStyles.primaryButtonStyle().copyWith(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFF5C3317)),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16)),
                ),
                child: _isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2),
                      )
                    : const Text('Scan Paket',
                        style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StaffScanScreen(shipment: widget.shipment),
                    ),
                  );
                },
                style: AppStyles.outlinedButtonStyle().copyWith(
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16)),
                ),
                child: const Text('Input Manual',
                    style: TextStyle(
                        color: Color(0xFF5C3317), fontWeight: FontWeight.w700)),
              ),
            ] else ...[
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
                    const Text('Hasil Deteksi Sistem',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 12),
                    _detailItem('Resi', widget.shipment.resi),
                    const SizedBox(height: 8),
                    _detailItem('Tujuan', widget.shipment.tujuan),
                    const SizedBox(height: 8),
                    _detailItem('Masuk', widget.shipment.tanggalMasuk),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isScanning
                    ? null
                    : () async {
                        final success = await context
                            .read<StaffProvider>()
                            .completeShipment(widget.shipment.id);
                        if (!mounted) return;
                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StaffScanCompleteScreen(
                                shipment: widget.shipment,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Gagal menyelesaikan proses paket.'),
                            ),
                          );
                        }
                      },
                style: AppStyles.primaryButtonStyle().copyWith(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFF5C3317)),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16)),
                ),
                child: const Text('Simpan',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(title,
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
