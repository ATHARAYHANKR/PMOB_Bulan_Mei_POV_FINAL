import 'package:flutter/material.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  static const List<_NotifikasiItem> _items = [
    _NotifikasiItem(
      title: 'Estimasi pengiriman diperbarui',
      subtitle: 'Perkiraan pengiriman paket Anda berubah menjadi 21 Mei 2024.',
      time: '05:30',
      date: 'Sel, 21 Mei 2024',
      color: Color(0xFFFFD54F),
    ),
    _NotifikasiItem(
      title: 'Paket telah dipindahkan',
      subtitle: 'Paket Anda telah dipindahkan ke gudang pusat Surabaya.',
      time: '12:15',
      date: 'Sel, 21 Mei 2024',
      color: Color(0xFF4CAF50),
    ),
    _NotifikasiItem(
      title: 'Paket tiba di Jakarta HUB',
      subtitle: 'Paket akan segera dikirim ke alamat tujuan Anda.',
      time: '09:40',
      date: 'Sen, 20 Mei 2024',
      color: Color(0xFF2196F3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C3317),
        elevation: 0,
        title: const Text('Notifikasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifikasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Update terbaru seputar paket Anda.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.notifications_active_rounded,
                            color: Color(0xFF5C3317), size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Semua notifikasi penting akan muncul di sini.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _NotificationTile(item: item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifikasiItem {
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final Color color;

  const _NotifikasiItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.color,
  });
}

class _NotificationTile extends StatelessWidget {
  final _NotifikasiItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(Icons.notifications_rounded, color: item.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50))),
                const SizedBox(height: 6),
                Text(item.subtitle,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF6B7280))),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(item.date,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF))),
                    const SizedBox(width: 8),
                    const Text('•',
                        style:
                            TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                    const SizedBox(width: 8),
                    Text(item.time,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
