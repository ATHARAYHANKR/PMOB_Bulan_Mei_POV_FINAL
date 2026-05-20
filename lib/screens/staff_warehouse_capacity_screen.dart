import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'package:provider/provider.dart';
import '../models/staff_model.dart';
import '../services/staff_provider.dart';

class StaffWarehouseCapacityScreen extends StatelessWidget {
  const StaffWarehouseCapacityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Kapasitas & Notifikasi',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<StaffProvider>(
          builder: (context, provider, _) {
            final warehouses = provider.warehouses;
            final notifications = provider.notifications;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Notifikasi Staf',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF2C3E50))),
                const SizedBox(height: 12),
                if (notifications.isEmpty)
                  const Text('Tidak ada notifikasi terbaru.',
                      style: TextStyle(color: Colors.grey))
                else
                  ...notifications.map((item) => _NotificationTile(item: item)),
                const SizedBox(height: 18),
                const Text('Kapasitas Gudang',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF2C3E50))),
                const SizedBox(height: 12),
                Expanded(
                  child: warehouses.isEmpty
                      ? const Center(child: Text('Tidak ada data gudang.'))
                      : GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.84,
                          children: warehouses.map((warehouse) {
                            final progress = warehouse.kapasitas > 0
                                ? warehouse.terpakai / warehouse.kapasitas
                                : 0.0;
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(warehouse.nama,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Color(0xFF2C3E50))),
                                  const SizedBox(height: 6),
                                  Text(warehouse.lokasi,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                  const SizedBox(height: 12),
                                  LinearProgressIndicator(
                                    value: progress.clamp(0, 1),
                                    color: const Color(0xFF5C3317),
                                    backgroundColor: Colors.grey.shade200,
                                    minHeight: 8,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      '${warehouse.terpakai.toInt()} dari ${warehouse.kapasitas.toInt()} paket terpakai',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: warehouse.needsTransfer
                                          ? Colors.orange.shade50
                                          : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(warehouse.prioritas,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: warehouse.needsTransfer
                                                ? Colors.orange.shade700
                                                : Colors.green.shade700)),
                                  ),
                                  const Spacer(),
                                  if (warehouse.needsTransfer)
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: AppStyles.primaryButtonStyle()
                                            .copyWith(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  const Color(0xFF5C3317)),
                                          padding: WidgetStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 12)),
                                        ),
                                        child: const Text('Alihkan paket',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    )
                                ],
                              ),
                            );
                          }).toList(),
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

class _NotificationTile extends StatelessWidget {
  final WarehouseNotification item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_active_rounded,
              color: Color(0xFF5C3317)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))),
                const SizedBox(height: 4),
                Text(item.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(item.time,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
