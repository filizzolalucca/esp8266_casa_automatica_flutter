import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../utils/adafruit_utils.dart';

class AdafruitMqttService {
  late MqttServerClient _client;
  bool _connected = false;

  final _streamController = StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get messages => _streamController.stream;

  Future<void> connect() async {
    if (_connected) return;

    _client = MqttServerClient(AdafruitUtils.server, '');
    _client.port = AdafruitUtils.port;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
    _client.secure = false;

    _client.onDisconnected = () {
      _connected = false;
      debugPrint('🔌 Desconectado do Adafruit IO');
    };
    _client.onConnected = () {
      _connected = true;
      debugPrint('✅ Conectado ao Adafruit IO');
    };

    final connMess = MqttConnectMessage()
        .authenticateAs(AdafruitUtils.username, AdafruitUtils.key)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } catch (e) {
      debugPrint('Erro de conexão: $e');
      _client.disconnect();
      return;
    }

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      final topic = c[0].topic;
      debugPrint('📩 [$topic] $payload');

      _streamController.add({topic: payload});
    });
  }

  void subscribe(String feedKey) {
    if (!_connected) return;
    final topic = AdafruitUtils.topic(feedKey);
    _client.subscribe(topic, MqttQos.atMostOnce);
  }

  void publish(String feedKey, String value) {
    if (!_connected) return;
    final builder = MqttClientPayloadBuilder()..addString(value);
    _client.publishMessage(
      AdafruitUtils.topic(feedKey),
      MqttQos.atMostOnce,
      builder.payload!,
      retain: true,
    );
  }

  void disconnect() {
    _client.disconnect();
    _connected = false;
  }
}
