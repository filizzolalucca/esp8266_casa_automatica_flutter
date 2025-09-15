class AdafruitUtils {
  static const String username = "FilizzolaLucca";
  static const String key = "aio_VbOk93BPx9cYXJXtAIycvT0Ei6Ko";
  static const String server = "io.adafruit.com";
  static const int port = 1883;

  // Feeds
  static const String feedTemperatura = "sensortemperatura";
  static const String feedUmidade = "sensorumidade";
  static const String feedL1 = "l1";
  static const String feedL2 = "l2";
  static const String feedS1 = "s1";

  static String topic(String feed) => "$username/feeds/$feed";
}
