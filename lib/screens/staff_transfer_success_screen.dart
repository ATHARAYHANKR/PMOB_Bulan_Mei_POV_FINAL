import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import '../models/staff_model.dart';

class StaffTransferSuccessScreen extends StatelessWidget {
  final WarehouseBatch batch;
  final WarehouseCenter warehouse;

  const StaffTransferSuccessScreen(
      {super.key, required this.batch, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C3317),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    size: 72, color: Colors.white),
              ),
              const SizedBox(height: 30),
              const Text('Berhasil Dialihkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50))),
              const SizedBox(height: 16),
              Text(
                'Batch ${batch.kode} berhasil dialihkan ke ${warehouse.nama}.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail Pengalihan',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 14),
                    _infoRow('Batch', batch.kode),
                    const SizedBox(height: 10),
                    _infoRow('Tujuan', batch.tujuan),
                    const SizedBox(height: 10),
                    _infoRow('Gudang', warehouse.nama),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: AppStyles.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: AppStyles.primaryButtonStyle().copyWith(
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xFF5C3317)),
                  ),
                  child: const Text('Kembali ke Dashboard',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50)))),
      ],
    );
  }
}
