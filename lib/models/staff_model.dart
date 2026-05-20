class WarehouseShipment {
  final String id;
  final String resi;
  final String pengirim;
  final String tujuan;
  final String status;
  final String tanggalMasuk;

  WarehouseShipment({
    required this.id,
    required this.resi,
    required this.pengirim,
    required this.tujuan,
    required this.status,
    required this.tanggalMasuk,
  });

  factory WarehouseShipment.fromJson(Map<String, dynamic> json) {
    return WarehouseShipment(
      id: json['id'].toString(),
      resi: json['resi'] ?? '',
      pengirim: json['pengirim'] ?? '',
      tujuan: json['tujuan'] ?? '',
      status: json['status'] ?? '',
      tanggalMasuk: json['tanggal_masuk'] ?? '',
    );
  }
}

class InventoryItem {
  final String id;
  final String nama;
  int stok;
  final String lokasi;

  InventoryItem({
    required this.id,
    required this.nama,
    required this.stok,
    required this.lokasi,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      stok: json['stok'] ?? 0,
      lokasi: json['lokasi'] ?? '',
    );
  }
}

class WarehouseBatch {
  final String id;
  final String kode;
  final String tujuan;
  final String status;
  final int jumlahPaket;
  final double totalBerat;
  final String gudangAsal;
  final String tanggalMasuk;
  final List<WarehousePackage> paket;

  WarehouseBatch({
    required this.id,
    required this.kode,
    required this.tujuan,
    required this.status,
    required this.jumlahPaket,
    required this.totalBerat,
    required this.gudangAsal,
    required this.tanggalMasuk,
    required this.paket,
  });

  factory WarehouseBatch.fromJson(Map<String, dynamic> json) {
    return WarehouseBatch(
      id: json['id'].toString(),
      kode: json['kode'] ?? '',
      tujuan: json['tujuan'] ?? '',
      status: json['status'] ?? '',
      jumlahPaket: json['jumlah_paket'] ?? 0,
      totalBerat: (json['total_berat'] ?? 0).toDouble(),
      gudangAsal: json['gudang_asal'] ?? '',
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      paket: (json['paket'] as List? ?? [])
          .map((item) => WarehousePackage.fromJson(item))
          .toList(),
    );
  }
}

class WarehousePackage {
  final String resi;
  final double berat;
  final String status;

  WarehousePackage({
    required this.resi,
    required this.berat,
    required this.status,
  });

  factory WarehousePackage.fromJson(Map<String, dynamic> json) {
    return WarehousePackage(
      resi: json['resi'] ?? '',
      berat: (json['berat'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}

class WarehouseCenter {
  final String id;
  final String nama;
  final String lokasi;
  final double kapasitas;
  final double terpakai;
  final double jarak;
  final String status;
  final String prioritas;

  WarehouseCenter({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.kapasitas,
    required this.terpakai,
    required this.jarak,
    required this.status,
    required this.prioritas,
  });

  factory WarehouseCenter.fromJson(Map<String, dynamic> json) {
    final kapasitas = (json['kapasitas'] ?? 0).toDouble();
    final terpakai = (json['terpakai'] ?? 0).toDouble();
    final ratio = kapasitas > 0 ? terpakai / kapasitas : 0.0;
    final priority = json['prioritas'] ??
        (ratio >= 0.85
            ? 'Tinggi'
            : ratio >= 0.65
                ? 'Sedang'
                : 'Rendah');

    return WarehouseCenter(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      lokasi: json['lokasi'] ?? '',
      kapasitas: kapasitas,
      terpakai: terpakai,
      jarak: (json['jarak'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      prioritas: priority,
    );
  }

  double get available => kapasitas - terpakai;
  bool get needsTransfer =>
      status.toLowerCase().contains('hampir penuh') ||
      (kapasitas > 0 && terpakai / kapasitas >= 0.85);
}

class WarehouseNotification {
  final String title;
  final String subtitle;
  final String time;
  final String severity;

  WarehouseNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.severity,
  });
}
