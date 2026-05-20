import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import '../models/courier_delivery_model.dart';

class CourierTaskCompleteScreen extends StatelessWidget {
  final CourierDelivery order;

  const CourierTaskCompleteScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    size: 72, color: Colors.white),
              ),
              const SizedBox(height: 26),
              const Text('Berhasil!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50))),
              const SizedBox(height: 14),
              Text(
                'Paket ${order.nomorResi} telah berhasil dikirim. Terima kasih telah menyelesaikan tugas hari ini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 28),
              Container(
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
                    const Text('Ringkasan Tugas',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 16),
                    _summaryRow('Total Paket', '1 Paket'),
                    const SizedBox(height: 10),
                    _summaryRow('Paket Terkirim', '1 Paket'),
                    const SizedBox(height: 10),
                    _summaryRow('Total Lokasi', '1 Lokasi'),
                    const SizedBox(height: 10),
                    _summaryRow('Waktu Kerja', '6 jam 24 menit'),
                    const SizedBox(height: 16),
                    const Text('Rating Sementara',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Color(0xFFFBC02D), size: 18),
                        SizedBox(width: 4),
                        Text('4.3',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: AppStyles.buttonHeight,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: AppStyles.primaryButtonStyle().copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(const Color(0xFF5C3317))),
                  child: const Text('Selesai',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: AppStyles.buttonHeight,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: AppStyles.outlinedButtonStyle(),
                  child: const Text('Lihat Riwayat',
                      style: TextStyle(
                          color: Color(0xFF5C3317),
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50))),
      ],
    );
  }
}
