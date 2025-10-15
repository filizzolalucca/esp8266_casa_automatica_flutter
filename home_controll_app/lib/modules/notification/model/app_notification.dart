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
}

enum NotificationType { presenca, campainha }
