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
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('🔔 Notificação clicada: ${response.payload}');
      },
    );

    if (Platform.isAndroid) {
      final androidImpl = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImpl?.requestNotificationsPermission();
    }

    if (Platform.isIOS) {
      final iosImpl = _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await _loadHistory(); // ✅ Carrega histórico salvo
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('notifications') ?? [];

    _history
      ..clear()
      ..addAll(
        jsonList.map(
          (json) => AppNotification.fromJson(jsonDecode(json)),
        ),
      );

    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _history.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList('notifications', jsonList);
  }

  Future<void> send(AppNotification notification) async {
    _history.add(notification);
    await _saveHistory();
    notifyListeners();

    final notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    const androidDetails = AndroidNotificationDetails(
      'home_security_channel',
      'Notificações de Segurança',
      channelDescription:
          'Alertas de presença e campainha da sua casa inteligente',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      threadIdentifier: 'home-security',
    );

    await _localNotifications.show(
      notificationId,
      notification.title,
      notification.description,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload:
          '${notification.type.index}_${notification.timestamp.toIso8601String()}',
    );

    debugPrint('✅ Notificação enviada e salva: ${notification.title}');
  }

  Future<void> clearAll() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    notifyListeners();
  }
}
