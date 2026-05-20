import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'package:provider/provider.dart';
import '../models/staff_model.dart';
import '../services/staff_provider.dart';
import 'staff_transfer_success_screen.dart';

class StaffWarehouseSelectionScreen extends StatelessWidget {
  final WarehouseBatch batch;

  const StaffWarehouseSelectionScreen({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Pilih Gudang Tujuan',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<StaffProvider>(
          builder: (context, provider, _) {
            final warehouses = provider.warehouses;
            if (warehouses.isEmpty) {
              return const Center(
                  child: Text('Tidak ada gudang tujuan tersedia.'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: warehouses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final warehouse = warehouses[index];
                      final progress = warehouse.terpakai / warehouse.kapasitas;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(warehouse.nama,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Color(0xFF2C3E50))),
                                      const SizedBox(height: 4),
                                      Text(warehouse.lokasi,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                Text('${(progress * 100).toInt()}%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF5C3317))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: progress,
                              color: const Color(0xFF5C3317),
                              backgroundColor: Colors.grey.shade200,
                              minHeight: 8,
                            ),
                            const SizedBox(height: 10),
                            Text(
                                '${warehouse.terpakai.toInt()}/${warehouse.kapasitas.toInt()} paket terpakai',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () async {
                                final success = await provider.transferBatch(
                                    batch.id, warehouse.id);
                                if (!context.mounted) return;
                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          StaffTransferSuccessScreen(
                                              batch: batch,
                                              warehouse: warehouse),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Gagal transfer batch')));
                                }
                              },
                              style: AppStyles.primaryButtonStyle().copyWith(
                                backgroundColor: WidgetStateProperty.all(
                                    const Color(0xFF5C3317)),
                              ),
                              child: const Text('Pilih Gudang',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
