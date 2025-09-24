import 'package:flutter/material.dart';

class SensorData {
  final double temperature;
  final double humidity; 

  SensorData({required this.temperature, required this.humidity});
}

enum SensorType {
  temperature,
  humidity,
  
}

extension SensorTypeExtension on SensorType {
  String get displayName {
    switch (this) {
      case SensorType.temperature:
        return 'Temperatura';
      case SensorType.humidity:
        return 'Umidade';
    }
  }
  
  IconData get icon {
    switch (this) {
      case SensorType.temperature:
        return Icons.thermostat;
      case SensorType.humidity:
        return Icons.water_drop;
    }
  }
}