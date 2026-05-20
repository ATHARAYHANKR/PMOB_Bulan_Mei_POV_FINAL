import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/staff_provider.dart';
import 'staff_overload_detail_screen.dart';

class StaffOverloadScreen extends StatelessWidget {
  const StaffOverloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Paket Overload',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<StaffProvider>(
        builder: (context, provider, _) {
          final batches = provider.overloadBatches;
          if (batches.isEmpty) {
            return const Center(
                child: Text('Tidak ada batch overload saat ini.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: batches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final batch = batches[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StaffOverloadDetailScreen(batch: batch),
                  ),
                ),
                child: Container(
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
                          Text(batch.kode,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5C3317))),
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
                      const SizedBox(height: 10),
                      Text('Tujuan: ${batch.tujuan}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text(
                          '${batch.jumlahPaket} paket • ${batch.totalBerat} kg',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF2C3E50))),
                      const SizedBox(height: 10),
                      Text('Gudang asal: ${batch.gudangAsal}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
