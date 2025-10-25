// lib/modules/notification/view_model/notification_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';
import 'package:home_controll_app/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _notificationService = GetIt.I<NotificationService>();

  List<AppNotification> get notifications => _notificationService.history.reversed.toList();

  void clearAll() {
    _notificationService.clearAll();
    notifyListeners();
  }
}
