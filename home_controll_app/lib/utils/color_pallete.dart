import 'package:flutter/material.dart';

class AppColors {

  // Cores de texto
  static const Color textPrimary = Color(0xFFFFFFFF);

  // Cores de icons
  static const Color icon = Color(0xFFFFFFFF);

  // Cores de fundo
  static const Color background = Color(0xFF1B1B19);
  static const Color black33 = Color(0x54000000);
 
  // Cores dos gradientes
  static const Color temperatureStart = Color(0xFF4884DD);
  static const Color temperatureMiddle = Color(0xFF7AFFCA);
  static const Color temperatureEnd = Color(0xFFFFCC7A);
  
  static const Color humidityStart = Color(0xFFFFCC7A);
  static const Color humidityMiddle = Color(0xFFFF8C70);
  static const Color humidityEnd = Color(0xFF4FBAF0);
  
  // Cores com opacidade
  static Color get temperatureStart75 => temperatureStart.withOpacity(0.75);
  static Color get temperatureEnd75 => temperatureEnd.withOpacity(0.75);
  static Color get humidityStart75 => humidityStart.withOpacity(0.75);
  static Color get humidityEnd75 => humidityEnd.withOpacity(0.75);
  
  // Cores neutras
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  static const Color alertYellow = Color(0xFFFFD54F);
}