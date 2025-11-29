class AppNotification {
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationType type;

  AppNotification({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'type': type.index,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NotificationType.values[json['type']],
    );
  }
  
}

enum NotificationType { presenca, campainha }
