import 'package:get_it/get_it.dart';
import 'package:home_controll_app/modules/settings/view_model/security_view_model.dart';
import 'package:home_controll_app/services/notification_service.dart';
import '../services/adafruit_mqtt_service.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  // NotificationService
  final notifier = NotificationService();
  await notifier.init();
  getIt.registerSingleton<NotificationService>(notifier);

  // AdafruitMqttService
  final mqtt = AdafruitMqttService();
  await mqtt.connect();
  mqtt.subscribeSecurityFeeds();
  getIt.registerSingleton<AdafruitMqttService>(mqtt);

  // SecurityViewModel
  getIt.registerSingleton<SecurityViewModel>(SecurityViewModel());
}