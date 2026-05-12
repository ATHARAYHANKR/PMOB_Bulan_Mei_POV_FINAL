import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tracking_model.dart';

class BinderbyteService {
  // Ganti dengan API key kalian dari binderbyte.com
  static const String _apiKey = 'MASUKKAN_API_KEY_BINDERBYTE_DISINI';
  static const String _baseUrl = 'https://api.binderbyte.com/v1/track';

  static const List<Map<String, String>> daftarEkspedisi = [
    {'code': 'jne', 'name': 'JNE'},
    {'code': 'jnt', 'name': 'J&T Express'},
    {'code': 'sicepat', 'name': 'SiCepat'},
    {'code': 'anteraja', 'name': 'Anteraja'},
    {'code': 'pos', 'name': 'Pos Indonesia'},
    {'code': 'tiki', 'name': 'TIKI'},
    {'code': 'ninja', 'name': 'Ninja Express'},
    {'code': 'lion', 'name': 'Lion Parcel'},
  ];

  Future<TrackingResult> trackPaket({
    required String resi,
    required String ekspedisi,
  }) async {
    // Jika API key belum diset, gunakan data dummy
    if (_apiKey == 'MASUKKAN_API_KEY_BINDERBYTE_DISINI') {
      await Future.delayed(const Duration(seconds: 2)); // simulasi loading
      return dummyTrackingResult(resi, ekspedisi);
    }

    try {
      final uri = Uri.parse(
        '$_baseUrl?api_key=$_apiKey&courier=$ekspedisi&awb=$resi',
      );

      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return TrackingResult.fromBinderbyte(json);
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
