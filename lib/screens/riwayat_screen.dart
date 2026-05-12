import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/tracking_provider.dart';
import '../models/riwayat_model.dart';
import 'detail_tracking_screen.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Riwayat',
            style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          Consumer<TrackingProvider>(
            builder: (context, provider, _) {
              final riwayat = provider.getRiwayat();
              if (riwayat.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Hapus Semua',
                onPressed: () => _konfirmasiHapusSemua(context, provider),
              );
            },
          ),
        ],
      ),
      body: Consumer<TrackingProvider>(
        builder: (context, provider, _) {
          final riwayat = provider.getRiwayat();

          if (riwayat.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lacak paket pertama kamu!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: riwayat.length,
            itemBuilder: (context, index) {
              final item = riwayat[index];
              return _RiwayatCard(
                item: item,
                onHapus: () => provider.hapusRiwayat(item),
                onLacakLagi: () => _lacakLagi(context, provider, item),
              );
            },
          );
        },
      ),
    );
  }

  void _lacakLagi(BuildContext context, TrackingProvider provider,
      RiwayatPengiriman item) {
    final kodeEkspedisi = item.ekspedisi.toLowerCase().replaceAll(' ', '');
    provider.setEkspedisi(kodeEkspedisi);
    provider.trackPaket(item.nomorResi).then((_) {
      if (provider.state == TrackingState.success && provider.result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DetailTrackingScreen(result: provider.result!),
          ),
        );
      }
    });
  }

  void _konfirmasiHapusSemua(
      BuildContext context, TrackingProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text(
            'Semua riwayat pengiriman akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.hapusSemuaRiwayat();
              Navigator.pop(ctx);
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final RiwayatPengiriman item;
  final VoidCallback onHapus;
  final VoidCallback onLacakLagi;

  const _RiwayatCard({
    required this.item,
    required this.onHapus,
    required this.onLacakLagi,
  });

  Color _statusColor(String status) {
    if (status.contains('DELIVERED') || status.contains('TERKIRIM')) {
      return Colors.green;
    } else if (status.contains('PROCESS') || status.contains('PROSES')) {
      return Colors.orange;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.statusTerakhir);
    final tanggal =
        DateFormat('dd MMM yyyy, HH:mm').format(item.tanggalCek);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C3317).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.ekspedisi,
                        style: const TextStyle(
                          color: Color(0xFF5C3317),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.statusTerakhir,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.nomorResi,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${item.pengirim} → ${item.penerima}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Dicek: $tanggal',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onLacakLagi,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Lacak Lagi'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF5C3317),
                  ),
                ),
              ),
              Container(width: 1, height: 36, color: Colors.grey.shade200),
              Expanded(
                child: TextButton.icon(
                  onPressed: onHapus,
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                  label: const Text('Hapus'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
