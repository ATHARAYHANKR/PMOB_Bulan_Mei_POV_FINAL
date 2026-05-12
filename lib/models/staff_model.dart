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
