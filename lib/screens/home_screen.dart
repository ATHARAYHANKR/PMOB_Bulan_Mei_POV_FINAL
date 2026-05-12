import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../services/tracking_provider.dart';
import 'search_screen.dart';
import 'notifikasi_screen.dart';
import '../models/riwayat_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> _couriers = [
    {'name': 'JNE', 'icon': Icons.local_shipping, 'color': Color(0xFFFF6B00)},
    {'name': 'J&T', 'icon': Icons.local_shipping, 'color': Color(0xFFD32F2F)},
    {'name': 'SiCepat', 'icon': Icons.flash_on, 'color': Color(0xFFFFD700)},
    {'name': 'AnterAja', 'icon': Icons.local_shipping, 'color': Color(0xFF0066CC)},
    {'name': 'Pos', 'icon': Icons.mail, 'color': Color(0xFF00B050)},
    {'name': 'TIKI', 'icon': Icons.inventory_2, 'color': Color(0xFFA020F0)},
    {'name': 'Ninja', 'icon': Icons.rocket_launch, 'color': Color(0xFF00D4FF)},
    {'name': 'Lion', 'icon': Icons.flight, 'color': Color(0xFFF5A623)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),

              // Ekspedisi yang didukung
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ekspedisi yang didukung',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3E50))),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _couriers.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.9),
                      itemBuilder: (context, i) {
                        final c = _couriers[i];
                        return _CourierItem(
                            name: c['name'],
                            icon: c['icon'],
                            color: c['color']);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Layanan lainnya
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Layanan lainnya',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2C3E50))),
                        Icon(Icons.chevron_right_rounded,
                            color: Colors.grey.shade400),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _LayananCard(
                            title: 'Kirim Paket',
                            subtitle: 'Kirim paket ke seluruh Indonesia',
                            icon: Icons.send_rounded,
                            iconBg: const Color(0xFFF5F7FA),
                            iconColor: const Color(0xFF5C3317),
                            isHighlighted: false,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LayananCard(
                            title: 'Lacak Paket',
                            subtitle:
                                'Cek status dan posisi paket Anda secara real-time',
                            icon: Icons.location_on_rounded,
                            iconBg: const Color(0xFF5C3317),
                            iconColor: Colors.white,
                            isHighlighted: true,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SearchScreen())),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Riwayat terakhir
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Riwayat terakhir',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3E50))),
                    const SizedBox(height: 12),
                    Consumer<TrackingProvider>(
                      builder: (context, provider, _) {
                        final items = provider.getRiwayat().take(3).toList();
                        if (items.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: const Center(
                                child: Text('Belum ada riwayat',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14))),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) =>
                              _RiwayatItem(item: items[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF5C3317),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFA0673A),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final name = (auth.currentUser?.fullName.isNotEmpty == true)
                        ? auth.currentUser!.fullName
                        : (auth.currentUser?.username ?? 'Pengguna');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, $name',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        const Text('Pantau paket anda dengan mudah!',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    );
                  },
                ),
              ),
              // Notifikasi icon dengan badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 26),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotifikasiScreen())),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE74C3C), shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search bar
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SearchScreen())),
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: Colors.grey.shade400, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Masukkan nomor resi',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                        color: const Color(0xFF5C3317),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('Lacak',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourierItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  const _CourierItem(
      {required this.name, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _LayananCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color iconBg, iconColor;
  final bool isHighlighted;
  final VoidCallback onTap;
  const _LayananCard(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.iconBg,
      required this.iconColor,
      required this.isHighlighted,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFF5C3317).withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isHighlighted
              ? Border.all(
                  color: const Color(0xFF5C3317).withValues(alpha: 0.3))
              : null,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50))),
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  final RiwayatPengiriman item;
  const _RiwayatItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: const Color(0xFF5C3317).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.local_shipping_rounded,
                color: Color(0xFF5C3317), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nomorResi,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50))),
                const SizedBox(height: 3),
                Text('${item.pengirim} → ${item.penerima}',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
