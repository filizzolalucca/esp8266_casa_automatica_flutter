// lib/modules/notification/view_model/notification_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';
import 'package:home_controll_app/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _notificationService = GetIt.I<NotificationService>();

  List<AppNotification> get notifications =>
      List.unmodifiable(_notificationService.history.reversed);

  NotificationViewModel() {
    _notificationService.addListener(_onNotificationsChanged);
  }

  void _onNotificationsChanged() {
    notifyListeners();
  }

  void clearAll() {
    _notificationService.clearAll();
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationsChanged);
    super.dispose();
  }
}