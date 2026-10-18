# Smart Home App (Flutter)

Mobile app to control an ESP8266-powered smart home in real time over MQTT, using [Adafruit IO](https://io.adafruit.com) as the broker.

This is the app side of our final-year project (TCC), built by Henrique Resende and Lucca Filizzola. The board firmware lives in [smart_home_tcc](https://github.com/filizzolalucca/smart_home_tcc).

<p>
  <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/MQTT-660066?logo=mqtt&logoColor=white" alt="MQTT">
  <img src="https://img.shields.io/badge/platforms-Android%20%7C%20iOS-lightgrey" alt="Platforms">
</p>

> The app's interface is in Brazilian Portuguese.

## Features

- **Rooms**: bedroom, kitchen and living room, each with a light you can switch on and off
- **Live climate**: temperature and humidity gauges updated as the board publishes new readings
- **Security mode**: get a push notification when the presence sensor detects someone
- **Doorbell**: get a notification whenever the doorbell button is pressed
- **Energy-saving mode**: lets the board dim a light based on ambient light
- **Notification history** screen with a clear-all option
- Secure MQTT connection (TLS, port 8883) that stays in sync with the board's state

## Tech stack

| | |
|---|---|
| Framework | Flutter |
| Architecture | MVVM with `provider` and `get_it` for dependency injection |
| Messaging | `mqtt_client` (Adafruit IO) |
| UI | `syncfusion_flutter_gauges`, `percent_indicator` |
| Notifications | `flutter_local_notifications` |
| Storage | `shared_preferences` |

## Project structure

```
home_controll_app/lib/
├── main.dart
├── components/            # Shared widgets (app bar, text)
├── modules/
│   ├── home/              # Rooms, lights and sensor cards
│   ├── notification/      # Notification history
│   └── settings/          # Security and energy-saving modes
├── services/
│   ├── adafruit_mqtt_service.dart
│   └── notification_service.dart
└── utils/                 # Adafruit IO settings, colors, dependency injection
```

## Getting started

1. Set your Adafruit IO username, key and feed names in `home_controll_app/lib/utils/adafruit_utils.dart`. Keep real keys out of commits.
2. Run the app:
   ```bash
   cd home_controll_app
   flutter pub get
   flutter run
   ```

## Authors

Henrique Resende and **Lucca Filizzola** · [@filizzolalucca](https://github.com/filizzolalucca)
