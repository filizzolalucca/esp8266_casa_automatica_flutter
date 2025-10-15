import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';
import 'package:home_controll_app/services/adafruit_mqtt_service.dart';
import 'package:home_controll_app/services/notification_service.dart';

class SecurityViewModel extends ChangeNotifier {
  final NotificationService _notifier = GetIt.I<NotificationService>();
  final AdafruitMqttService _mqtt = GetIt.I<AdafruitMqttService>();

  bool modoSeguranca = false;
  bool economiaEnergia = false;
  DateTime? _lastPresenceNotification;

  SecurityViewModel() {
    _mqtt.listenSecurityFeeds(_handleMessage);
    _mqtt.listenEconomyFeeds(_handleEconomyMessage);
    _mqtt.subscribe('modoeconomia');
  }

  void toggleSeguranca(bool value) {
    modoSeguranca = value;
    notifyListeners();
    _mqtt.publish('modoseguranca', value ? '1' : '0');
  }

  void toggleEconomiaEnergia(bool value) {
    economiaEnergia = value;
    notifyListeners();
    _mqtt.publish('modoeconomia', value ? '1' : '0');
  }

  void _handleEconomyMessage(String topic, String payload) {
    final feedKey = topic.split('/').last.toLowerCase();

    if (feedKey == 'modoeconomia') {
      economiaEnergia = payload == '1';
      debugPrint('💡 Modo economia atualizado: $economiaEnergia');
      notifyListeners();
    }
  }

  void _handleMessage(String topic, String payload) {
    final feedKey = topic.split('/').last.toLowerCase();
    final now = DateTime.now();

    if (feedKey == 's1') {
      final detected = payload == "1";
      if (modoSeguranca && detected) {
        if (_lastPresenceNotification == null ||
            now.difference(_lastPresenceNotification!) > const Duration(minutes: 5)) {
          _lastPresenceNotification = now;
          _notifier.send(AppNotification(
            title: "Detectado presença",
            description: "Foi detectada presença na sua casa.",
            timestamp: now,
            type: NotificationType.presenca,
          ));
        }
      }
    }

    if (feedKey == 'btn') {
      final pressed = payload == "1";
      if (pressed) {
        _notifier.send(AppNotification(
          title: "Campainha",
          description: "",
          timestamp: now,
          type: NotificationType.campainha,
        ));
      }
    }

    if (feedKey == 'modoseguranca') {
      modoSeguranca = payload == '1';
      debugPrint('🔒 Modo segurança atualizado: $modoSeguranca');
      notifyListeners();
    }
  }
}
