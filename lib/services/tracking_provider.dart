import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/tracking_model.dart';
import '../models/riwayat_model.dart';
import 'api_service.dart';

enum TrackingState { idle, loading, success, error }

class TrackingProvider extends ChangeNotifier {
  TrackingState _state = TrackingState.idle;
  TrackingResult? _result;
  String _errorMessage = '';
  String _selectedEkspedisi = 'jne';
  List<RiwayatPengiriman> _riwayat = [];

  TrackingState get state => _state;
  TrackingResult? get result => _result;
  String get errorMessage => _errorMessage;
  String get selectedEkspedisi => _selectedEkspedisi;

  void setEkspedisi(String kode) {
    _selectedEkspedisi = kode;
    notifyListeners();
  }

  Future<void> trackPaket(String resi) async {
    _state = TrackingState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.post('/track', {
        'resi': resi,
        'ekspedisi': _selectedEkspedisi,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _result = TrackingResult.fromJson(data);
        _state = TrackingState.success;
      } else {
        _state = TrackingState.error;
        _errorMessage = 'Nomor resi tidak ditemukan';
      }
    } catch (e) {
      _state = TrackingState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  Future<void> loadRiwayat() async {
    try {
      final response = await ApiService.get('/history');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _riwayat =
            data.map((item) => RiwayatPengiriman.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  void reset() {
    _state = TrackingState.idle;
    _result = null;
    _errorMessage = '';
    notifyListeners();
  }

  List<RiwayatPengiriman> getRiwayat() {
    return _riwayat;
  }

  Future<void> hapusRiwayat(RiwayatPengiriman item) async {
    // For now, just remove from local list
    _riwayat.remove(item);
    notifyListeners();
  }

  Future<void> hapusSemuaRiwayat() async {
    _riwayat.clear();
    notifyListeners();
  }

  /// Initialize dummy data untuk demo (10+ items)
  Future<void> initializeDummyData() async {
    final box = Hive.box<RiwayatPengiriman>('riwayat');

    if (box.isNotEmpty) return; // Jangan overwrite jika sudah ada data

    final dummyData = [
      RiwayatPengiriman(
        nomorResi: 'JNE123456789',
        ekspedisi: 'JNE',
        statusTerakhir: 'TERKIRIM',
        tanggalCek: DateTime.now().subtract(const Duration(days: 1)),
        pengirim: 'Jakarta Pusat',
        penerima: 'Bandung',
      ),
      RiwayatPengiriman(
        nomorResi: 'JT987654321',
        ekspedisi: 'J&T',
        statusTerakhir: 'DALAM PROSES',
        tanggalCek: DateTime.now(),
        pengirim: 'Surabaya',
        penerima: 'Malang',
      ),
      RiwayatPengiriman(
        nomorResi: 'SICEPAT111111',
        ekspedisi: 'SiCepat',
        statusTerakhir: 'TERKIRIM',
        tanggalCek: DateTime.now().subtract(const Duration(hours: 2)),
        pengirim: 'Yogyakarta',
        penerima: 'Solo',
      ),
      RiwayatPengiriman(
        nomorResi: 'ANTERAJA222222',
        ekspedisi: 'Anteraja',
        statusTerakhir: 'DALAM PROSES',
        tanggalCek: DateTime.now().subtract(const Duration(minutes: 30)),
        pengirim: 'Medan',
        penerima: 'Aceh',
      ),
      RiwayatPengiriman(
        nomorResi: 'POSID333333',
        ekspedisi: 'Pos ID',
        statusTerakhir: 'TERKIRIM',
        tanggalCek: DateTime.now().subtract(const Duration(days: 3)),
        pengirim: 'Makassar',
        penerima: 'Manado',
      ),
      RiwayatPengiriman(
        nomorResi: 'TIKI444444',
        ekspedisi: 'TIKI',
        statusTerakhir: 'PROSES',
        tanggalCek: DateTime.now().subtract(const Duration(hours: 1)),
        pengirim: 'Palembang',
        penerima: 'Jambi',
      ),
      RiwayatPengiriman(
        nomorResi: 'NINJA555555',
        ekspedisi: 'Ninja',
        statusTerakhir: 'TERKIRIM',
        tanggalCek: DateTime.now().subtract(const Duration(days: 2)),
        pengirim: 'Semarang',
        penerima: 'Pekalongan',
      ),
      RiwayatPengiriman(
        nomorResi: 'LION666666',
        ekspedisi: 'Lion',
        statusTerakhir: 'DALAM PROSES',
        tanggalCek: DateTime.now().subtract(const Duration(hours: 5)),
        pengirim: 'Denpasar',
        penerima: 'Gili Meno',
      ),
      RiwayatPengiriman(
        nomorResi: 'JNE777777',
        ekspedisi: 'JNE',
        statusTerakhir: 'TERKIRIM',
        tanggalCek: DateTime.now().subtract(const Duration(days: 5)),
        pengirim: 'Kupang',
        penerima: 'Dili',
      ),
      RiwayatPengiriman(
        nomorResi: 'JT888888',
        ekspedisi: 'J&T',
        statusTerakhir: 'PROSES',
        tanggalCek: DateTime.now().subtract(const Duration(hours: 12)),
        pengirim: 'Tersangkut',
        penerima: 'Jakarta',
      ),
      RiwayatPengiriman(
        nomorResi: 'SICEPAT999999',
        ekspedisi: 'SiCepat',
        statusTerakhir: 'TERKIRIM',
        tanggalCek: DateTime.now().subtract(const Duration(days: 4)),
        pengirim: 'Pontianak',
        penerima: 'Kuching',
      ),
    ];

    for (var item in dummyData) {
      await box.add(item);
    }

    notifyListeners();
  }
}
