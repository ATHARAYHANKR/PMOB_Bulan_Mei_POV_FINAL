import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/courier_delivery_model.dart';
import 'api_service.dart';

class CourierProvider extends ChangeNotifier {
  bool _isOnline = false;
  List<CourierDelivery> _activeOrders = [];
  List<CourierDelivery> _history = [];

  bool get isOnline => _isOnline;

  List<CourierDelivery> get activeOrders => List.unmodifiable(_activeOrders);

  List<CourierDelivery> get history => List.unmodifiable(_history);

  Future<void> loadOrders() async {
    try {
      final response = await ApiService.get('/courier/orders');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _activeOrders =
            data.map((item) => CourierDelivery.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> loadHistory() async {
    try {
      final response = await ApiService.get('/courier/history');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _history = data.map((item) => CourierDelivery.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleOnlineStatus() async {
    try {
      final response = await ApiService.post('/courier/toggle-online', {});
      if (response.statusCode == 200) {
        _isOnline = !_isOnline;
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> markPicked(String id) async {
    await updateStatus(id, 'Dalam pengiriman');
    final order = _activeOrders.firstWhere((o) => o.id == id,
        orElse: () => throw Exception('Order tidak ditemukan'));
    order.isPicked = true;
    order.status = 'Dalam pengiriman';
    notifyListeners();
  }

  Future<void> completeOrder(String id) async {
    final orderIndex = _activeOrders.indexWhere((o) => o.id == id);
    if (orderIndex == -1) return;

    final completedOrder = _activeOrders.removeAt(orderIndex);
    completedOrder.status = 'Selesai';
    _history.insert(0, completedOrder);
    notifyListeners();
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      final response = await ApiService.put('/courier/orders/$id/status', {
        'status': status,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedOrder = CourierDelivery.fromJson(data);
        final index = _activeOrders.indexWhere((o) => o.id == id);
        if (index != -1) {
          _activeOrders[index] = updatedOrder;
          notifyListeners();
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  CourierDelivery? getOrderById(String id) {
    try {
      return _activeOrders.firstWhere((o) => o.id == id);
    } catch (_) {
      try {
        return _history.firstWhere((o) => o.id == id);
      } catch (_) {
        return null;
      }
    }
  }
}
