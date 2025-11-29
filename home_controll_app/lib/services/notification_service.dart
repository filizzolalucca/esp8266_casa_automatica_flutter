import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final List<AppNotification> _history = [];

  List<AppNotification> get history => List.unmodifiable(_history);

  Future<void> init() async {
    await _loadFromStorage(); // ✅ Carrega histórico local

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(initSettings);

    if (Platform.isAndroid) {
      final androidImpl = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    }

    if (Platform.isIOS) {
      final iosImpl = _localNotifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
    }

    notifyListeners();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList("notifications") ?? [];

    _history
      ..clear()
      ..addAll(saved.map((e) => AppNotification.fromJson(jsonDecode(e))));
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "notifications",
      _history.map((n) => jsonEncode(n.toJson())).toList(),
    );
  }

  void clearAll() {
    _history.clear();
    _saveToStorage(); // ✅ salva
    notifyListeners();
  }

  Future<void> send(AppNotification notification) async {
    _history.add(notification);
    await _saveToStorage(); // ✅ salva
    notifyListeners();

    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    await _localNotifications.show(
      id,
      notification.title,
      notification.description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'home_security_channel',
          'Notificações de Segurança',
          channelDescription: 'Alertas de segurança da casa inteligente',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
    );
  }
}