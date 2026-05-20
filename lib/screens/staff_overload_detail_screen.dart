import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import '../models/staff_model.dart';
import 'staff_warehouse_selection_screen.dart';

class StaffOverloadDetailScreen extends StatelessWidget {
  final WarehouseBatch batch;

  const StaffOverloadDetailScreen({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Detail Paket Overload',
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
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Batch ${batch.kode}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF2C3E50))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: batch.status == 'Overload'
                              ? Colors.orange.shade50
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(batch.status,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: batch.status == 'Overload'
                                    ? Colors.orange.shade700
                                    : const Color(0xFF2C3E50))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (batch.status == 'Overload')
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Prioritas Tinggi: Segera alihkan batch ini ke gudang ketersediaan lebih besar.',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A4B0A)),
                      ),
                    ),
                  _detailRow('Tujuan', batch.tujuan),
                  const SizedBox(height: 10),
                  _detailRow('Tujuan', batch.tujuan),
                  const SizedBox(height: 10),
                  _detailRow('Total Paket', '${batch.jumlahPaket} paket'),
                  const SizedBox(height: 10),
                  _detailRow('Total Berat', '${batch.totalBerat} kg'),
                  const SizedBox(height: 10),
                  _detailRow('Gudang Asal', batch.gudangAsal),
                  const SizedBox(height: 10),
                  _detailRow('Tanggal Masuk', batch.tanggalMasuk),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Daftar paket dalam batch',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: batch.paket.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final paket = batch.paket[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
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
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_outlined,
                            color: Color(0xFF5C3317)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(paket.resi,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2C3E50))),
                              const SizedBox(height: 4),
                              Text('${paket.berat} kg • ${paket.status}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StaffWarehouseSelectionScreen(batch: batch),
                  ),
                );
              },
              style: AppStyles.primaryButtonStyle().copyWith(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFF5C3317)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16)),
              ),
              child: const Text('Alihkan Paket',
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
                style: const TextStyle(fontSize: 12, color: Colors.grey))),
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
