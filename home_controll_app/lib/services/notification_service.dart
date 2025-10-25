import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';

class NotificationService {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final List<AppNotification> _history = [];

  List<AppNotification> get history => List.unmodifiable(_history);

  void clearAll() => _history.clear();

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
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidImplementation?.requestNotificationsPermission();
      debugPrint('🔔 Permissão de notificação: $granted');
    }

    // Solicita permissão no iOS (simulador e físico)
    if (Platform.isIOS) {
      final iosImpl = _localNotifications
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('🔔 Permissão de notificação iOS: $granted');
    }
  }

  Future<void> send(AppNotification notification) async {
    _history.add(notification);

    final notificationId = DateTime.now().millisecondsSinceEpoch % 100000;

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
      const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
       // Adicione para iOS
    badgeNumber: 1,
    threadIdentifier: 'home-security',
    );

     try {
    await _localNotifications.show(
      notificationId,
      notification.title,
      notification.description,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: '${notification.type.toString()}_${notification.timestamp.millisecondsSinceEpoch}',
    );
    
    debugPrint('✅ Notificação enviada: ${notification.title}');
  } catch (e) {
    debugPrint('❌ Erro ao enviar notificação: $e');
  }
  }
}