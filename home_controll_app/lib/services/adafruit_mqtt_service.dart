import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../utils/adafruit_utils.dart';

class AdafruitMqttService {
  late MqttServerClient _client;
  bool _connected = false;

  // Stream broadcast para múltiplos listeners
  final _streamController = StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get messages => _streamController.stream;

  /// Conecta ao Adafruit IO
  Future<void> connect() async {
    if (_connected) return;

    _client = MqttServerClient(AdafruitUtils.server, '');
    _client.port = AdafruitUtils.port;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
    _client.secure = true;
    _client.securityContext = SecurityContext.defaultContext;

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

    // Escuta todas as mensagens recebidas
    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = c[0].topic;
      debugPrint('📩 [$topic] $payload');

      _streamController.add({topic: payload});
    });
  }

  /// Subscribes aos feeds de segurança
  void subscribeSecurityFeeds() {
    if (!_connected) return;
    final feeds = ['modoseguranca', 's1', 'btn'];
    for (var feed in feeds) {
      final topic = AdafruitUtils.topic(feed);
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
  }

  void subscribeEconomyFeeds() {
    if (!_connected) return;
    final feeds = ['modoeconomia'];
    for (var feed in feeds) {
      final topic = AdafruitUtils.topic(feed);
      _client.subscribe(topic, MqttQos.atMostOnce);
      debugPrint('💡 Subscribed to economy feed: $feed');
    }
  }

  /// Subscribes a qualquer feed genérico (incluindo modo economia ou luzes)
  void subscribe(String feedKey) {
    if (!_connected) return;
    debugPrint('🔔 Subscribing to $feedKey');
    _client.subscribe(AdafruitUtils.topic(feedKey), MqttQos.atMostOnce);
  }

  /// Publica uma mensagem em qualquer feed
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

  /// Desconecta do broker
  void disconnect() {
    _client.disconnect();
    _connected = false;
  }

  /// Helper opcional para ouvir apenas feeds de segurança via callback
  void listenSecurityFeeds(Function(String topic, String payload) callback) {
    messages.listen((msg) {
      final topic = msg.keys.first;
      final payload = msg.values.first;
      if (['modoseguranca', 's1', 'btn'].any((feed) => topic.endsWith(feed))) {
        callback(topic, payload);
      }
    });
  }

  void listenEconomyFeeds(Function(String topic, String payload) callback) {
    messages.listen((msg) {
      final topic = msg.keys.first;
      final payload = msg.values.first;
      if (['modoeconomia'].any((feed) => topic.endsWith(feed))) {
        callback(topic, payload);
      }
    });
  }
}