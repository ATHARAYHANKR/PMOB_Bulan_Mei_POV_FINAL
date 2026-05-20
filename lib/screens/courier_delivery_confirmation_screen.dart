import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'package:provider/provider.dart';
import '../models/courier_delivery_model.dart';
import '../services/courier_provider.dart';
import 'courier_task_complete_screen.dart';

class CourierDeliveryConfirmationScreen extends StatelessWidget {
  final CourierDelivery order;

  const CourierDeliveryConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Konfirmasi Pengiriman',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rute Pengantaran',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade100,
                    ),
                    child: const Center(
                      child: Icon(Icons.map_rounded,
                          size: 72, color: Color(0xFF5C3317)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _statusBadge('Sedang menuju lokasi', true),
                  const SizedBox(height: 16),
                  _infoRow('Nomor Resi', order.nomorResi),
                  const SizedBox(height: 10),
                  _infoRow('Penerima', order.penerima),
                  const SizedBox(height: 10),
                  _infoRow('Alamat', order.alamatAntar),
                  const SizedBox(height: 10),
                  _infoRow('Estimasi', order.estimasi),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Konfirmasi Penerima',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  _infoRow('Nama Penerima', order.penerima),
                  const SizedBox(height: 12),
                  _infoRow('No. Telepon', '0812-3456-7890'),
                  const SizedBox(height: 12),
                  const Text('Kondisi Paket',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C3E50))),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: const [
                      _ConditionChip(label: 'Baik', selected: true),
                      _ConditionChip(label: 'Segel/Lakban', selected: false),
                      _ConditionChip(label: 'Isi Paket', selected: false),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Foto Bukti Pengiriman',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.photo_camera_outlined,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('Ambil foto paket setelah diserahkan',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: AppStyles.outlinedButtonStyle(),
                          child: const Text('Ambil ulang foto',
                              style: TextStyle(
                                  color: Color(0xFF5C3317),
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: AppStyles.outlinedButtonStyle(),
                          child: const Text('Pilih dari Galeri',
                              style: TextStyle(
                                  color: Color(0xFF5C3317),
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<CourierProvider>();
                await provider.startDelivery(order.id);
                await provider.completeOrder(order.id);
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CourierTaskCompleteScreen(order: order)),
                );
              },
              style: AppStyles.primaryButtonStyle().copyWith(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFF5C3317))),
              child: const Text('Lanjut ke Tugas Berikutnya',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F5E9) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: active ? const Color(0xFF2E7D32) : Colors.grey.shade700)),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(title,
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

class _ConditionChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _ConditionChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF5C3317) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF2C3E50),
              fontWeight: FontWeight.w700,
              fontSize: 12)),
    );
  }
}
