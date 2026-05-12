import 'package:flutter/material.dart';

class BuktiFotoScreen extends StatefulWidget {
  final String nomorResi;
  const BuktiFotoScreen({super.key, required this.nomorResi});

  @override
  State<BuktiFotoScreen> createState() => _BuktiFotoScreenState();
}

class _BuktiFotoScreenState extends State<BuktiFotoScreen> {
  bool _sudahDisimpan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color(0xFF2C3E50), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Pengiriman',
            style: TextStyle(
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w700,
                fontSize: 17)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu ringkasan
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF6B00).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.local_shipping_rounded,
                            color: Color(0xFFFF6B00), size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('JNE Regular',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF2C3E50))),
                          Text('Diperbarui 10 menit lalu',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined,
                          size: 16, color: Color(0xFF5C3317)),
                      const SizedBox(width: 6),
                      Text(widget.nomorResi,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF2C3E50))),
                      const SizedBox(width: 6),
                      const Icon(Icons.copy_rounded,
                          size: 14, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Jakarta',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(height: 1, color: Colors.grey.shade300),
                            const Icon(Icons.arrow_forward_rounded,
                                size: 14, color: Color(0xFF5C3317)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Surabaya',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bukti Foto Paket
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bukti Foto Paket',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF2C3E50))),
                  const SizedBox(height: 4),
                  Text(
                    'Foto ini diambil saat paket diterima di lokasi transit',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),

                  // Foto paket (placeholder)
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFF5C3317).withOpacity(0.4),
                          width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Simulasi foto paket dengan box coklat
                        Container(
                          width: 150,
                          height: 130,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA0673A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.inventory_2_rounded,
                                  color: Colors.white, size: 40),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                color: Colors.white,
                                child: Text(
                                  widget.nomorResi,
                                  style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Label JNE
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B00),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('JNE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Diambil pada: 21 Maret 2026, 08:20 WIB',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Tombol unduh / simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _unduhFoto(context),
                      icon: const Icon(
                          Icons.download_rounded,
                          size: 18),
                      label: const Text('Unduh Foto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C3317),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dialog berhasil disimpan (overlay)
            if (_sudahDisimpan) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C3317).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF5C3317), size: 36),
                    ),
                    const SizedBox(height: 12),
                    const Text('Berhasil disimpan!',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF2C3E50))),
                    const SizedBox(height: 6),
                    Text('Foto telah tersimpan di galeri perangkat Anda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _unduhFoto(BuildContext context) {
    setState(() => _sudahDisimpan = true);
    // Di implementasi nyata: gunakan image_gallery_saver atau permission_handler
  }
}
