import 'package:flutter/material.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/modules/notification/model/app_notification.dart';
import 'package:home_controll_app/utils/color_pallete.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM').format(notification.timestamp);
    final time = DateFormat('HH:mm').format(notification.timestamp);

    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.presenca:
        icon = Icons.warning_amber_rounded;
        iconColor = AppColors.alertYellow;
        break;
      case NotificationType.campainha:
        icon = Icons.notifications_active_outlined;
        iconColor = AppColors.icon;
        break;
    }

    final semanticDescription = notification.type == NotificationType.presenca
        ? "Alerta de movimento detectado às $time"
        : "Campainha tocada às $time";

    return Semantics(
      container: true,
      label: notification.title,
      hint: semanticDescription,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: TextApp(
          text: notification.title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        subtitle: notification.type == NotificationType.presenca
            ? TextApp(
                text: notification.description,
                fontSize: 14,
                color: AppColors.grey500,
                fontWeight: FontWeight.normal,
              )
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextApp(
              text: date,
              fontSize: 12,
              color: AppColors.grey500,
              fontWeight: FontWeight.normal,
            ),
            TextApp(
              text: time,
              fontSize: 12,
              color: AppColors.grey500,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}
