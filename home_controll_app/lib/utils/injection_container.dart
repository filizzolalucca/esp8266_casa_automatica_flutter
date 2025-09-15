import 'package:get_it/get_it.dart';
import '../services/adafruit_mqtt_service.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  getIt.registerLazySingleton<AdafruitMqttService>(() => AdafruitMqttService());
}
