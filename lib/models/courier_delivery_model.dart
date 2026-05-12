class CourierDelivery {
  final String id;
  final String nomorResi;
  final String ekspedisi;
  final String pengirim;
  final String penerima;
  final String alamatAmbil;
  final String alamatAntar;
  final String estimasi;
  String status;
  bool isPicked;
  String? buktiFoto;

  CourierDelivery({
    required this.id,
    required this.nomorResi,
    required this.ekspedisi,
    required this.pengirim,
    required this.penerima,
    required this.alamatAmbil,
    required this.alamatAntar,
    required this.estimasi,
    required this.status,
    this.isPicked = false,
    this.buktiFoto,
  });

  factory CourierDelivery.fromJson(Map<String, dynamic> json) {
    return CourierDelivery(
      id: json['id'].toString(),
      nomorResi: json['nomor_resi'] ?? '',
      ekspedisi: json['ekspedisi'] ?? '',
      pengirim: json['pengirim'] ?? '',
      penerima: json['penerima'] ?? '',
      alamatAmbil: json['alamat_ambil'] ?? '',
      alamatAntar: json['alamat_antar'] ?? '',
      estimasi: json['estimasi'] ?? '',
      status: json['status'] ?? '',
      isPicked: json['is_picked'] ?? false,
      buktiFoto: json['bukti_foto'],
    );
  }

  bool get isDelivered => status.toLowerCase().contains('selesai');
}
