import 'package:flutter/foundation.dart';
import 'package:home_controll_app/modules/home/models/room_item.dart';
import 'package:home_controll_app/services/adafruit_mqtt_service.dart';

import '../../../utils/injection_container.dart';
import '../models/sensor_data.dart';
import '../../../utils/adafruit_utils.dart';

class HomeViewModel extends ChangeNotifier {
  final AdafruitMqttService _mqtt = getIt<AdafruitMqttService>();

  SensorData _data = SensorData(temperature: 0, humidity: 0);
  SensorData get data => _data;

  final List<RoomItem> _rooms = [
    RoomItem(id: '1', name: 'Sala'),
    RoomItem(id: '2', name: 'Cozinha'),
    RoomItem(id: '3', name: 'Quarto'),
    RoomItem(id: '4', name: 'Quarto de Visita'),
  ];
  List<RoomItem> get rooms => List.unmodifiable(_rooms);

  HomeViewModel() {
    _connect();
  }

  Future<void> _connect() async {
    await _mqtt.connect(); // conecta em segundo plano
    _mqtt.subscribe(AdafruitUtils.feedTemperatura);
    _mqtt.subscribe(AdafruitUtils.feedUmidade);

    _mqtt.messages.listen((message) {
      message.forEach((topic, value) {
        if (topic.endsWith(AdafruitUtils.feedTemperatura)) {
          _data = SensorData(
            temperature: double.tryParse(value) ?? 0,
            humidity: _data.humidity,
          );
        } else if (topic.endsWith(AdafruitUtils.feedUmidade)) {
          _data = SensorData(
            temperature: _data.temperature,
            humidity: double.tryParse(value) ?? 0,
          );
        }
      });
      notifyListeners();
    });
  }
}