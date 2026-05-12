import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/staff_model.dart';
import 'api_service.dart';

class StaffProvider extends ChangeNotifier {
  bool _isAvailable = true;
  List<WarehouseShipment> _incomingShipments = [];
  List<InventoryItem> _inventory = [];
  Map<String, dynamic> _dashboardData = {};

  bool get isAvailable => _isAvailable;

  List<WarehouseShipment> get incomingShipments =>
      List.unmodifiable(_incomingShipments);

  List<InventoryItem> get inventory => List.unmodifiable(_inventory);

  int get shipmentCount => _dashboardData['incoming_count'] ?? 0;

  int get inventoryCount => _dashboardData['inventory_count'] ?? 0;

  int get lowStockCount => _dashboardData['low_stock_count'] ?? 0;

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

  Future<void> loadIncomingShipments() async {
    try {
      final response = await ApiService.get('/staff/incoming');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _incomingShipments =
            data.map((item) => WarehouseShipment.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
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
}
