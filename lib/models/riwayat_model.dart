import 'package:hive/hive.dart';

part 'riwayat_model.g.dart';

@HiveType(typeId: 0)
class RiwayatPengiriman extends HiveObject {
  @HiveField(0)
  String nomorResi;

  @HiveField(1)
  String ekspedisi;

  @HiveField(2)
  String statusTerakhir;

  @HiveField(3)
  DateTime tanggalCek;

  @HiveField(4)
  String pengirim;

  @HiveField(5)
  String penerima;

  RiwayatPengiriman({
    required this.nomorResi,
    required this.ekspedisi,
    required this.statusTerakhir,
    required this.tanggalCek,
    required this.pengirim,
    required this.penerima,
  });

  factory RiwayatPengiriman.fromJson(Map<String, dynamic> json) {
    return RiwayatPengiriman(
      nomorResi: json['nomor_resi'] ?? '',
      ekspedisi: json['ekspedisi'] ?? '',
      statusTerakhir: json['status_terakhir'] ?? '',
      tanggalCek: DateTime.parse(
          json['tanggal_cek'] ?? DateTime.now().toIso8601String()),
      pengirim: json['pengirim'] ?? '',
      penerima: json['penerima'] ?? '',
    );
  }
}
