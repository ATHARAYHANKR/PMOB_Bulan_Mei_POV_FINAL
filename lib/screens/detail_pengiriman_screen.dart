import 'package:flutter/material.dart';
import 'paket_saya_screen.dart';
import 'bukti_foto_screen.dart';

class DetailPengirimanScreen extends StatelessWidget {
  final PaketTersimpan paket;
  const DetailPengirimanScreen({super.key, required this.paket});

  static const List<Map<String, dynamic>> _riwayatPerjalanan = [
    {
      'waktu': '14:00\n06:30',
      'tanggal': '23 Mei 2024',
      'status': 'Paket telah diterima',
      'desc': 'Penerima: Aoos. Lihat bukti pengiriman',
      'isAktif': true,
      'adaBukti': true,
    },
    {
      'waktu': '22 Mei\n09:44',
      'tanggal': '',
      'status': 'Pesanan dalam perjalanan menuju ke lokasi anda.',
      'desc': 'Lihat bukti paket',
      'isAktif': false,
      'adaBukti': true,
    },
    {
      'waktu': '20 Mei\n09:06',
      'tanggal': '',
      'status':
          'Pesanan dipindai di lokasi transit Kota Surabaya, Gunung Anyar Hub.',
      'desc': 'Lihat bukti paket',
      'isAktif': false,
      'adaBukti': true,
    },
    {
      'waktu': '20 Mei\n04:28',
      'tanggal': '',
      'status':
          'Pesanan dipindai di lokasi transit Kota Surabaya, Gunung Anyar Hub.',
      'desc': 'Lihat bukti paket',
      'isAktif': false,
      'adaBukti': true,
    },
    {
      'waktu': '19 Mei\n03:58',
      'tanggal': '',
      'status': 'Pesanan berada di sortir di Kota Jakarta Timur, Cakung DC.',
      'desc': 'Lihat bukti paket',
      'isAktif': false,
      'adaBukti': true,
    },
    {
      'waktu': '19 Mei\n03:19',
      'tanggal': '',
      'status': 'Pesanan dipindai di lokasi transit Kota Jakarta Timur.',
      'desc': 'Lihat bukti paket',
      'isAktif': false,
      'adaBukti': true,
    },
    {
      'waktu': '19 Mei\n01:49',
      'tanggal': '',
      'status': 'Pesanan tiba di lokasi transit Kota Jakarta Timur.',
      'desc': 'Lihat bukti paket',
      'isAktif': false,
      'adaBukti': true,
    },
    {
      'waktu': '18 Mei\n07:58',
      'tanggal': '',
      'status': 'Pesanan disarankan ke juru kirim.',
      'desc': '',
      'isAktif': false,
      'adaBukti': false,
    },
  ];

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
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        centerTitle: false,
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Color(0xFF2C3E50)),
                  onPressed: () {}),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildRiwayatPerjalanan(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: const Color(0xFFFF6B00).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.local_shipping_rounded,
                    color: Color(0xFFFF6B00), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(paket.ekspedisi,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF2C3E50))),
                    Text('Diperbarui 10 menit lalu',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 16),
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
              const Icon(Icons.copy_rounded, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(paket.asal,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
              Text(paket.tujuan,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatPerjalanan(BuildContext context) {
    return Container(
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
          // Header riwayat
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Riwayat Pengiriman',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF2C3E50))),
                    Text('No. Resi: ${paket.nomorResi}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              // Tombol Bukti Foto
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            BuktiFotoScreen(nomorResi: paket.nomorResi))),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C3317).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Bukti Foto Paket',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF5C3317),
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(_riwayatPerjalanan.length, (i) {
            final item = _riwayatPerjalanan[i];
            final isLast = i == _riwayatPerjalanan.length - 1;
            return _TimelineItem(
              waktu: item['waktu'],
              status: item['status'],
              desc: item['desc'],
              isAktif: item['isAktif'],
              adaBukti: item['adaBukti'],
              isLast: isLast,
              onLihatBukti: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          BuktiFotoScreen(nomorResi: paket.nomorResi))),
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String waktu, status, desc;
  final bool isAktif, adaBukti, isLast;
  final VoidCallback onLihatBukti;

  const _TimelineItem({
    required this.waktu,
    required this.status,
    required this.desc,
    required this.isAktif,
    required this.adaBukti,
    required this.isLast,
    required this.onLihatBukti,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waktu
          SizedBox(
            width: 52,
            child: Text(
              waktu,
              style: TextStyle(
                  fontSize: 10,
                  color:
                      isAktif ? const Color(0xFF5C3317) : Colors.grey.shade400,
                  fontWeight: isAktif ? FontWeight.w700 : FontWeight.normal),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          // Dot + line
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color:
                      isAktif ? const Color(0xFF5C3317) : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: isAktif
                      ? Border.all(
                          color: const Color(0xFF5C3317).withValues(alpha: 0.3),
                          width: 3)
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          // Konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isAktif ? FontWeight.w700 : FontWeight.w500,
                          color: isAktif
                              ? const Color(0xFF2C3E50)
                              : Colors.grey.shade600)),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    GestureDetector(
                      onTap: adaBukti ? onLihatBukti : null,
                      child: Text(
                        desc,
                        style: TextStyle(
                            fontSize: 11,
                            color: adaBukti
                                ? const Color(0xFF5C3317)
                                : Colors.grey.shade500,
                            decoration:
                                adaBukti ? TextDecoration.underline : null),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
