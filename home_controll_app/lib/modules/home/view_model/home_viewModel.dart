import 'package:flutter/material.dart';
import 'package:home_controll_app/modules/home/models/room_item.dart';
import 'package:home_controll_app/modules/home/models/sensor_data.dart';
import 'package:home_controll_app/utils/adafruit_utils.dart';
import 'package:home_controll_app/utils/injection_container.dart';
import 'package:home_controll_app/services/adafruit_mqtt_service.dart';

class HomeViewModel extends ChangeNotifier with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this); // 👈 observa o ciclo de vida
    _connect();
  }

  // 🔌 Conexão principal MQTT
  Future<void> _connect() async {
    await _mqtt.connect();

    _mqtt.subscribe(AdafruitUtils.feedTemperatura);
    _mqtt.subscribe(AdafruitUtils.feedUmidade);
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
        } else if (topic.endsWith(AdafruitUtils.feedL1) ||
            topic.endsWith(AdafruitUtils.feedL2) ||
            topic.endsWith(AdafruitUtils.feedL3)) {
          final feedKey = topic.split('/').last.toLowerCase();
          final isOn = (value == "1" || value.toUpperCase() == "ON");
          _lights[feedKey] = isOn;
          debugPrint('💡 Estado salvo: $feedKey = $isOn');
        }
      });
      notifyListeners();
    });
  }

  // 💡 Alternar estado de uma luz
  void toggleLight(String roomFeedKey) {
    final key = roomFeedKey.toLowerCase();
    final current = _lights[key] ?? false;
    final newState = !current;

    debugPrint("Trocando $key para ${newState ? "ON" : "OFF"}");
    _lights[key] = newState;
    _mqtt.publish(key, newState ? "1" : "0");
    notifyListeners();
  }

  // 🔁 Reconnect automático quando o app volta pro foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // App voltou pro foreground → reconecta se estiver desconectado
      if (!_mqtt.isConnected) {
        debugPrint('🔄 Reconnectando ao Adafruit IO...');
        await _connect();
      }
    } else if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      // App minimizado ou fechado → encerra a conexão limpa
      _mqtt.disconnect();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mqtt.disconnect();
    super.dispose();
  }
}
