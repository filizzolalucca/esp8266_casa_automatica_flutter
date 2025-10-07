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
    RoomItem(id: '1', name: 'Quarto', type: RoomType.bedroom),
    RoomItem(id: '2', name: 'Cozinha', type: RoomType.kitchen),
    RoomItem(id: '3', name: 'Sala', type: RoomType.livingRoom),
  ];
  List<RoomItem> get rooms => List.unmodifiable(_rooms);

  final Map<String, bool> _lights = {};
  Map<String, bool> get lights => _lights;

  HomeViewModel() {
    _connect();
  }

  Future<void> _connect() async {
    await _mqtt.connect();
    _mqtt.subscribe(AdafruitUtils.feedTemperatura);
    _mqtt.subscribe(AdafruitUtils.feedUmidade);


    // Increve nas luzes
    _mqtt.subscribe(AdafruitUtils.feedL1);
    _mqtt.subscribe(AdafruitUtils.feedL2);
    _mqtt.subscribe(AdafruitUtils.feedL3);

    _mqtt.messages.listen((message) {
      message.forEach((topic, value) {

        debugPrint('🔔 feed extraido: $topic -> $value');
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
        } else if (
          topic.endsWith(AdafruitUtils.feedL1) ||
          topic.endsWith(AdafruitUtils.feedL2) ||
          topic.endsWith(AdafruitUtils.feedL3)) {
            final feedKey = topic.split('/').last.toLowerCase(); // <── extrai apenas "l1"
            final isOn = (value == "1" || value.toUpperCase() == "ON");
            _lights[feedKey] = isOn; // <── salva usando a mesma chave que a UI usa
            debugPrint('💡 Estado salvo: $feedKey = $isOn');
        }
      });
      notifyListeners();
    });
  }

  void toggleLight(String roomFeedKey) {
   final key = roomFeedKey.toLowerCase();
  final current = _lights[key] ?? false;
  final newState = !current;

  print("Trocando $key para ${newState ? "ON" : "OFF"}");
  _lights[key] = newState;
  _mqtt.publish(key, newState ? "1" : "0");
  notifyListeners();
  }
}