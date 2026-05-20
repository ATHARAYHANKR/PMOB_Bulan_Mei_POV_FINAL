import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'detail_pengiriman_screen.dart';
import 'search_screen.dart';

class PaketTersimpan {
  final String nomorResi;
  final String ekspedisi;
  final String estimasi;
  final String asal;
  final String tujuan;
  final String status;
  final DateTime updatedAt;

  const PaketTersimpan({
    required this.nomorResi,
    required this.ekspedisi,
    required this.estimasi,
    required this.asal,
    required this.tujuan,
    required this.status,
    required this.updatedAt,
  });
}

final List<PaketTersimpan> _dummyPaket = [
  PaketTersimpan(
    nomorResi: 'INT200791NKLSH789',
    ekspedisi: 'JNE Regular',
    estimasi: 'Estimasi 2 - 3 Hari',
    asal: 'Jakarta',
    tujuan: 'Surabaya',
    status: 'diproses',
    updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
];

class PaketSayaScreen extends StatefulWidget {
  const PaketSayaScreen({super.key});
  @override
  State<PaketSayaScreen> createState() => _PaketSayaScreenState();
}

class _PaketSayaScreenState extends State<PaketSayaScreen> {
  String _filterAktif = 'Semua';
  final List<String> _filters = ['Semua', 'Diproses', 'Dikirim', 'Selesai'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PaketTersimpan> get _filteredPaket {
    var list = _dummyPaket;
    if (_filterAktif != 'Semua') {
      list = list
          .where((p) => p.status.toLowerCase() == _filterAktif.toLowerCase())
          .toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((p) =>
              p.nomorResi.toLowerCase().contains(q) ||
              p.ekspedisi.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'dikirim':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'selesai':
        return 'Selesai';
      case 'dikirim':
        return 'Dikirim';
      default:
        return 'Diproses';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header cokelat solid
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              color: const Color(0xFF5C3317),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Paket Saya',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 2),
                            Text(
                                'Detail hanya bisa dibuka dari paket yang\nsudah disimpan',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.notifications_outlined,
                                  color: Colors.white),
                              onPressed: () {}),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFE74C3C),
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Search bar
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: Colors.grey.shade400, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Cari resi atau ekspedisi',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((f) {
                        final active = _filterAktif == f;
                        return GestureDetector(
                          onTap: () => setState(() => _filterAktif = f),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: active ? Colors.white : Colors.white24,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(f,
                                style: TextStyle(
                                    color: active
                                        ? const Color(0xFF5C3317)
                                        : Colors.white,
                                    fontWeight: active
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // List paket
            Expanded(
              child: _filteredPaket.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Hasil tidak ditemukan',
                              style: TextStyle(
                                  color: Color(0xFF2C3E50),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text('Coba gunakan kata kunci\nyang berbeda',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 13)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SearchScreen())),
                            style: AppStyles.primaryButtonStyle().copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                  const Color(0xFF5C3317)),
                            ),
                            child: const Text('Lacak Paket Baru'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredPaket.length,
                      itemBuilder: (context, index) {
                        final paket = _filteredPaket[index];
                        final statusColor = _statusColor(paket.status);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B00)
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                        Icons.local_shipping_rounded,
                                        color: Color(0xFFFF6B00),
                                        size: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(paket.ekspedisi,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                                color: Color(0xFF2C3E50))),
                                        Text(paket.estimasi,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          statusColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _statusLabel(paket.status),
                                      style: TextStyle(
                                          color: statusColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 16),

                              // Resi
                              Row(
                                children: [
                                  const Icon(Icons.receipt_long_outlined,
                                      size: 16, color: Color(0xFF5C3317)),
                                  const SizedBox(width: 6),
                                  Text(paket.nomorResi,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xFF2C3E50))),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.copy_rounded,
                                      size: 14, color: Colors.grey),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Rute
                              Row(
                                children: [
                                  Text(paket.asal,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                            height: 1,
                                            color: Colors.grey.shade300),
                                        const Icon(Icons.arrow_forward_rounded,
                                            size: 14, color: Color(0xFF5C3317)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(paket.tujuan,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600)),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Hapus + Lihat Detail
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _konfirmasiHapus(context, paket),
                                      icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 16),
                                      label: const Text('Hapus'),
                                      style: AppStyles.outlinedButtonStyle()
                                          .copyWith(
                                        foregroundColor:
                                            WidgetStateProperty.all(Colors.red),
                                        side: WidgetStateProperty.all(
                                            const BorderSide(
                                                color: Colors.red)),
                                        padding: WidgetStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 8)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  DetailPengirimanScreen(
                                                      paket: paket))),
                                      icon: const Icon(
                                          Icons.visibility_outlined,
                                          size: 16),
                                      label: const Text('Lihat Detail'),
                                      style: AppStyles.primaryButtonStyle()
                                          .copyWith(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                const Color(0xFF5C3317)),
                                        elevation: WidgetStateProperty.all(0),
                                        padding: WidgetStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context, PaketTersimpan paket) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Paket?'),
        content: Text('Resi ${paket.nomorResi} akan dihapus dari daftar.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() => _dummyPaket.remove(paket));
              Navigator.pop(context);
            },
            style: AppStyles.primaryButtonStyle().copyWith(
              backgroundColor: WidgetStateProperty.all(Colors.red),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
