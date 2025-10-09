import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';

class NotificationService {
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
  await _localNotifications.initialize(initSettings);

  if (Platform.isAndroid) {
    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidImplementation?.requestNotificationsPermission();
    debugPrint('🔔 Permissão de notificação: $granted');
  }
}

  Future<void> send(AppNotification notification) async {
    _history.add(notification);

    const androidDetails = AndroidNotificationDetails(
      'home_security_channel', // ID único
      'Notificações de Segurança', // Nome do canal
      channelDescription: 'Alertas de presença e campainha da sua casa inteligente',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      );

    // Configurações para iOS
    const iosDetails = DarwinNotificationDetails();

    await _localNotifications.show(
      0,
      notification.title,
      notification.description,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}