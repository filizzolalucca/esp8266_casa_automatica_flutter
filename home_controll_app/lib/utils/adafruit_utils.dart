class AdafruitUtils {
  static const String username = "FilizzolaLucca";
  static const String key = "aio_Zljk91wipMVbmY6GeirTYwu8CVzl";
  static const String server = "io.adafruit.com";
  static const int port = 8883;

  // Feeds
  static const String feedTemperatura = "sensortemperatura";
  static const String feedUmidade = "sensorumidade";
  static const String feedL1 = "l1";
  static const String feedL2 = "l2";
  static const String feedL3 = "l3";
  static const String feedS1 = "s1";

  static String topic(String feed) => "$username/feeds/$feed";
}
