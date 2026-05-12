class TrackingResult {
  final bool success;
  final String nomorResi;
  final String ekspedisi;
  final String status;
  final String pengirim;
  final String penerima;
  final String estimasi;
  final List<TrackingHistory> history;

  TrackingResult({
    required this.success,
    required this.nomorResi,
    required this.ekspedisi,
    required this.status,
    required this.pengirim,
    required this.penerima,
    required this.estimasi,
    required this.history,
  });

  factory TrackingResult.fromBinderbyte(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final summary = data['summary'] ?? {};
    final detail = data['detail'] as List? ?? [];

    return TrackingResult(
      success: json['status'] == 200,
      nomorResi: summary['awb'] ?? '-',
      ekspedisi: summary['courier'] ?? '-',
      status: summary['status'] ?? '-',
      pengirim: summary['origin'] ?? '-',
      penerima: summary['destination'] ?? '-',
      estimasi: summary['date'] ?? '-',
      history: detail.map((e) => TrackingHistory.fromJson(e)).toList(),
    );
  }
}

class TrackingHistory {
  final String tanggal;
  final String keterangan;
  final String lokasi;

  TrackingHistory({
    required this.tanggal,
    required this.keterangan,
    required this.lokasi,
  });

  factory TrackingHistory.fromJson(Map<String, dynamic> json) {
    return TrackingHistory(
      tanggal: json['date'] ?? '-',
      keterangan: json['desc'] ?? '-',
      lokasi: json['location'] ?? '-',
    );
  }
}

// Data dummy untuk testing tanpa API key
TrackingResult dummyTrackingResult(String resi, String ekspedisi) {
  return TrackingResult(
    success: true,
    nomorResi: resi,
    ekspedisi: ekspedisi.toUpperCase(),
    status: 'ON PROCESS',
    pengirim: 'Jakarta Pusat',
    penerima: 'Surabaya',
    estimasi: '2-3 Hari',
    history: [
      TrackingHistory(
        tanggal: '2026-04-08 14:30',
        keterangan: 'Paket sedang dalam perjalanan menuju kota tujuan',
        lokasi: 'Surabaya Hub',
      ),
      TrackingHistory(
        tanggal: '2026-04-08 08:00',
        keterangan: 'Paket diterima di gudang transit',
        lokasi: 'Semarang Transit',
      ),
      TrackingHistory(
        tanggal: '2026-04-07 20:15',
        keterangan: 'Paket telah diambil dari pengirim',
        lokasi: 'Jakarta Pusat',
      ),
      TrackingHistory(
        tanggal: '2026-04-07 15:00',
        keterangan: 'Pesanan dikonfirmasi dan siap diproses',
        lokasi: 'Jakarta Pusat',
      ),
    ],
  );
}
