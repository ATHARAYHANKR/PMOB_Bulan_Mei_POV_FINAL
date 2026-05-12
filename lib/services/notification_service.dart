import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(initSettings);
  }

  static Future<void> tampilkanNotifikasi({
    required String resi,
    required String status,
    required String ekspedisi,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'trackly_channel',
      'TRACKLY Notifikasi',
      channelDescription: 'Notifikasi update status pengiriman',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF1E3A5F),
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      resi.hashCode,
      '📦 Update Pengiriman $ekspedisi',
      'Resi $resi: $status',
      details,
    );
  }
}
