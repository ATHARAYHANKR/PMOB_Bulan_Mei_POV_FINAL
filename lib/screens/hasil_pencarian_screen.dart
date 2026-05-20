import 'package:flutter/material.dart';
import 'paket_saya_screen.dart';
import '../utils/shared_styles.dart';

class HasilPencarianScreen extends StatelessWidget {
  final String nomorResi;
  const HasilPencarianScreen({super.key, required this.nomorResi});

  static const String _ekspedisi = 'JNE Regular';
  static const String _estimasi = 'Estimasi 2 - 3 Hari';
  static const String _asal = 'Jakarta';
  static const String _tujuan = 'Surabaya';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color(0xFF2C3E50), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Hasil Pencarian',
            style: TextStyle(
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: Colors.grey.shade400, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(nomorResi,
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF2C3E50))),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kartu hasil
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ekspedisi row
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFF6B00).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.local_shipping_rounded,
                            color: Color(0xFFFF6B00), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(_ekspedisi,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Color(0xFF2C3E50))),
                            Text(_estimasi,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: Colors.grey),
                    ],
                  ),

                  const Divider(height: 20),

                  // Nomor resi
                  Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined,
                          size: 16, color: Color(0xFF5C3317)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(nomorResi,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF2C3E50))),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.copy_rounded,
                            size: 16, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Rute asal → tujuan
                  Row(
                    children: [
                      Text(_asal,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(height: 1, color: Colors.grey.shade300),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  3,
                                  (_) => Container(
                                        width: 5,
                                        height: 5,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        decoration: const BoxDecoration(
                                            color: Color(0xFF5C3317),
                                            shape: BoxShape.circle),
                                      )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_tujuan,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showSimpanDialog(context),
                      style: AppStyles.primaryButtonStyle().copyWith(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xFF5C3317)),
                          elevation: WidgetStateProperty.all(0)),
                      child: const Text('Simpan',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSimpanDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                    color: Color(0xFF5C3317), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Berhasil disimpan!',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF2C3E50))),
              const SizedBox(height: 8),
              Text('Paket telah ditambahkan\nke Paket Saya',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PaketSayaScreen()),
                    );
                  },
                  style: AppStyles.primaryButtonStyle().copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(const Color(0xFF5C3317)),
                      elevation: WidgetStateProperty.all(0)),
                  child: const Text('Lihat di Paket Saya',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: AppStyles.outlinedButtonStyle(),
                  child: const Text('Cari Resi Lain',
                      style: TextStyle(
                          color: Color(0xFF5C3317),
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
