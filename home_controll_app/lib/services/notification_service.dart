import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';

class NotificationService {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final List<AppNotification> _history = [];

  List<AppNotification> get history => List.unmodifiable(_history);

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Configurações para iOS
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(initSettings);
  }

  Future<void> send(AppNotification notification) async {
    _history.add(notification);

    const androidDetails = AndroidNotificationDetails(
      'security_channel',
      'Segurança',
      importance: Importance.max,
      priority: Priority.high,
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