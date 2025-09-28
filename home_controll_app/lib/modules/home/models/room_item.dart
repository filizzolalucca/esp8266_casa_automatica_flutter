import 'package:flutter/material.dart';
import 'package:home_controll_app/utils/adafruit_utils.dart';

enum RoomType { bedroom, livingRoom, kitchen }

class RoomItem {
  final String name;
  final String id;
  final RoomType type;

  RoomItem({required this.name, required this.id, required this.type});


  String get feedKey {
    switch (type) {
      case RoomType.bedroom:
        return AdafruitUtils.feedL1;
      case RoomType.livingRoom:
        return AdafruitUtils.feedL2;
      case RoomType.kitchen:
        return AdafruitUtils.feedL3;
    }
  }

  IconData get icon {
    switch (type) {
      case RoomType.bedroom:
        return Icons.bed;
      case RoomType.livingRoom:
        return Icons.tv;
      case RoomType.kitchen:
        return Icons.restaurant;
    }
  }
}