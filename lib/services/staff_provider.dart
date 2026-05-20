import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/staff_model.dart';
import 'api_service.dart';

class StaffProvider extends ChangeNotifier {
  bool _isAvailable = true;
  List<WarehouseShipment> _incomingShipments = [];
  List<InventoryItem> _inventory = [];
  List<WarehouseBatch> _overloadBatches = [];
  List<WarehouseCenter> _warehouses = [];
  List<WarehousePackage> _warehousePackages = [];
  List<WarehouseNotification> _notifications = [];
  Timer? _notificationTimer;
  Map<String, dynamic> _dashboardData = {};

  bool get isAvailable => _isAvailable;
  List<WarehousePackage> get warehousePackages =>
      List.unmodifiable(_warehousePackages);
  List<WarehouseNotification> get notifications =>
      List.unmodifiable(_notifications);

  List<WarehouseShipment> get incomingShipments =>
      List.unmodifiable(_incomingShipments);

  List<InventoryItem> get inventory => List.unmodifiable(_inventory);

  List<WarehouseBatch> get overloadBatches =>
      List.unmodifiable(_overloadBatches);

  List<WarehouseCenter> get warehouses => List.unmodifiable(_warehouses);

  int get shipmentCount => _dashboardData['incoming_count'] ?? 0;

  int get inventoryCount => _dashboardData['inventory_count'] ?? 0;

  int get lowStockCount => _dashboardData['low_stock_count'] ?? 0;

  StaffProvider() {
    _initializeDummyNotifications();
    _startRealtimeNotifications();
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  Future<void> loadDashboard() async {
    try {
      final response = await ApiService.get('/staff/dashboard');
      if (response.statusCode == 200) {
        _dashboardData = jsonDecode(response.body);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> loadOverloadBatches() async {
    try {
      final response = await ApiService.get('/staff/overload');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _overloadBatches =
            data.map((item) => WarehouseBatch.fromJson(item)).toList();
        notifyListeners();
      } else if (_overloadBatches.isEmpty) {
        _initializeDummyOverload();
      }
    } catch (e) {
      if (_overloadBatches.isEmpty) _initializeDummyOverload();
    }
  }

  Future<void> loadWarehouses() async {
    try {
      final response = await ApiService.get('/staff/warehouses');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _warehouses =
            data.map((item) => WarehouseCenter.fromJson(item)).toList();
        notifyListeners();
      } else if (_warehouses.isEmpty) {
        _initializeDummyWarehouses();
      }
    } catch (e) {
      if (_warehouses.isEmpty) _initializeDummyWarehouses();
    }
  }

  Future<void> loadWarehousePackages() async {
    try {
      final response = await ApiService.get('/staff/warehouse-packages');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _warehousePackages =
            data.map((item) => WarehousePackage.fromJson(item)).toList();
        notifyListeners();
      } else if (_warehousePackages.isEmpty) {
        _initializeDummyWarehousePackages();
      }
    } catch (e) {
      if (_warehousePackages.isEmpty) _initializeDummyWarehousePackages();
    }
  }

  Future<void> loadNotifications() async {
    try {
      final response = await ApiService.get('/staff/notifications');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _notifications = data
            .map((item) => WarehouseNotification(
                  title: item['title'] ?? '',
                  subtitle: item['subtitle'] ?? '',
                  time: item['time'] ?? '',
                  severity: item['severity'] ?? 'normal',
                ))
            .toList();
        notifyListeners();
      } else if (_notifications.isEmpty) {
        _initializeDummyNotifications();
      }
    } catch (e) {
      if (_notifications.isEmpty) _initializeDummyNotifications();
    }
  }

  void _initializeDummyWarehousePackages() {
    _warehousePackages = [
      WarehousePackage(resi: 'JNE123456789001', berat: 3.2, status: 'Menunggu'),
      WarehousePackage(resi: 'JNE123456789002', berat: 2.5, status: 'Overload'),
      WarehousePackage(resi: 'JNE123456789003', berat: 1.4, status: 'Selesai'),
      WarehousePackage(resi: 'JNE123456789004', berat: 2.9, status: 'Menunggu'),
      WarehousePackage(resi: 'JNE123456789005', berat: 3.8, status: 'Menunggu'),
      WarehousePackage(resi: 'JNE123456789006', berat: 2.1, status: 'Overload'),
      WarehousePackage(resi: 'JNE123456789007', berat: 1.7, status: 'Selesai'),
    ];
    notifyListeners();
  }

  void _initializeDummyNotifications() {
    _notifications = [
      WarehouseNotification(
        title: 'Batch overload masuk',
        subtitle: 'Batch BATCH-20240510-001 perlu alihkan ke gudang lain.',
        time: '1 mnt lalu',
        severity: 'high',
      ),
      WarehouseNotification(
        title: 'Kapasitas gudang hampir penuh',
        subtitle: 'Gudang D tersisa hanya 10 paket lagi.',
        time: '12 mnt lalu',
        severity: 'medium',
      ),
      WarehouseNotification(
        title: 'Shipment menunggu scan',
        subtitle: '3 paket menunggu proses scan di Gudang Utama.',
        time: '30 mnt lalu',
        severity: 'normal',
      ),
    ];
    notifyListeners();
  }

  void _startRealtimeNotifications() {
    _notificationTimer?.cancel();
    _notificationTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      final now = DateTime.now();
      final newNotif = WarehouseNotification(
        title: 'Update kapasitas gudang',
        subtitle:
            'Gudang C sekarang mencapai ${80 + now.second % 10}% kapasitas.',
        time: '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        severity: 'medium',
      );
      _notifications.insert(0, newNotif);
      if (_notifications.length > 5) {
        _notifications.removeLast();
      }
      notifyListeners();
    });
  }

  void _initializeDummyOverload() {
    _overloadBatches = [
      WarehouseBatch(
        id: '1',
        kode: 'BATCH-20240510-001',
        tujuan: 'Jakarta Selatan',
        status: 'Overload',
        jumlahPaket: 7,
        totalBerat: 12.3,
        gudangAsal: 'Gudang A',
        tanggalMasuk: '21 Mei 2026',
        paket: List.generate(
          7,
          (index) => WarehousePackage(
            resi: 'JNE12345678900${index + 1}',
            berat: 1.8 + index * 0.2,
            status: index == 0 ? 'Overload' : 'Menunggu',
          ),
        ),
      ),
    ];
    notifyListeners();
  }

  void _initializeDummyWarehouses() {
    _warehouses = [
      WarehouseCenter(
        id: 'a',
        nama: 'Gudang B',
        lokasi: 'Jl. A. Yani No. 5, Bekasi',
        kapasitas: 120,
        terpakai: 78,
        jarak: 12,
        status: 'Tersedia',
        prioritas: 'Sedang',
      ),
      WarehouseCenter(
        id: 'b',
        nama: 'Gudang C',
        lokasi: 'Jl. Merdeka No. 23, Jakarta',
        kapasitas: 100,
        terpakai: 40,
        jarak: 22,
        status: 'Tersedia',
        prioritas: 'Rendah',
      ),
      WarehouseCenter(
        id: 'c',
        nama: 'Gudang D',
        lokasi: 'Jl. Sudirman No. 32, Bandung',
        kapasitas: 90,
        terpakai: 80,
        jarak: 38,
        status: 'Hampir penuh',
        prioritas: 'Tinggi',
      ),
    ];
    notifyListeners();
  }

  Future<void> loadIncomingShipments() async {
    try {
      final response = await ApiService.get('/staff/incoming');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _incomingShipments =
            data.map((item) => WarehouseShipment.fromJson(item)).toList();
        if (_incomingShipments.isEmpty) _initializeDummyIncomingShipments();
        notifyListeners();
      } else if (_incomingShipments.isEmpty) {
        _initializeDummyIncomingShipments();
      }
    } catch (e) {
      if (_incomingShipments.isEmpty) _initializeDummyIncomingShipments();
    }
  }

  void _initializeDummyIncomingShipments() {
    _incomingShipments = [
      WarehouseShipment(
        id: '101',
        resi: 'JNE20012345001',
        pengirim: 'Gudang Utama',
        tujuan: 'Jakarta Selatan',
        status: 'Menunggu',
        tanggalMasuk: '20 Mei 2026',
      ),
      WarehouseShipment(
        id: '102',
        resi: 'SICEPAT20012345002',
        pengirim: 'Gudang Timur',
        tujuan: 'Bekasi',
        status: 'Dalam Proses',
        tanggalMasuk: '20 Mei 2026',
      ),
      WarehouseShipment(
        id: '103',
        resi: 'JNT20012345003',
        pengirim: 'Gudang Barat',
        tujuan: 'Depok',
        status: 'Menunggu',
        tanggalMasuk: '19 Mei 2026',
      ),
    ];
    notifyListeners();
  }

  Future<void> loadInventory() async {
    try {
      final response = await ApiService.get('/staff/inventory');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _inventory = data.map((item) => InventoryItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleAvailability() async {
    try {
      final response = await ApiService.post('/staff/toggle-availability', {});
      if (response.statusCode == 200) {
        _isAvailable = !_isAvailable;
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<bool> transferBatch(
      String batchId, String destinationWarehouseId) async {
    final batchIndex = _overloadBatches.indexWhere((b) => b.id == batchId);
    if (batchIndex == -1) return false;

    try {
      final response = await ApiService.post('/staff/batches/$batchId/transfer',
          {'warehouse_id': destinationWarehouseId});
      if (response.statusCode == 200) {
        _overloadBatches.removeAt(batchIndex);
        notifyListeners();
        return true;
      }
    } catch (_) {
      _overloadBatches.removeAt(batchIndex);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> receiveShipment(String id) async {
    try {
      final response = await ApiService.put('/staff/shipments/$id/receive', {});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedShipment = WarehouseShipment.fromJson(data);
        final index = _incomingShipments.indexWhere((s) => s.id == id);
        if (index != -1) {
          _incomingShipments[index] = updatedShipment;
          notifyListeners();
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> markReadyToPack(String id) async {
    try {
      final response = await ApiService.put('/staff/shipments/$id/ready', {});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedShipment = WarehouseShipment.fromJson(data);
        final index = _incomingShipments.indexWhere((s) => s.id == id);
        if (index != -1) {
          _incomingShipments[index] = updatedShipment;
          notifyListeners();
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<bool> completeShipment(String id) async {
    final index = _incomingShipments.indexWhere((s) => s.id == id);
    if (index == -1) return false;

    try {
      final response =
          await ApiService.put('/staff/shipments/$id/complete', {});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedShipment = WarehouseShipment.fromJson(data);
        _incomingShipments[index] = updatedShipment;
        notifyListeners();
        return true;
      }
    } catch (e) {
      final shipment = _incomingShipments[index];
      _incomingShipments[index] = WarehouseShipment(
        id: shipment.id,
        resi: shipment.resi,
        pengirim: shipment.pengirim,
        tujuan: shipment.tujuan,
        status: 'Selesai',
        tanggalMasuk: shipment.tanggalMasuk,
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
