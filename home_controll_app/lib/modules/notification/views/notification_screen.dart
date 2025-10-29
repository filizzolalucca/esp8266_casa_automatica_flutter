// lib/modules/notification/views/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:home_controll_app/components/app_bar.dart';
import 'package:home_controll_app/modules/notification/view_model/notification_viewModel.dart';
import 'package:home_controll_app/modules/notification/views/components/notification_item.dart';
import 'package:provider/provider.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/utils/color_pallete.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: Consumer<NotificationViewModel>(
        builder: (context, vm, _) {
          final history = vm.notifications;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomBackAppBar(
              title: "Notificações",
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            body: history.isEmpty
                ? Center(
                    child: Semantics(
                      label: "Sem notificações",
                      hint: "Nenhuma notificação foi recebida até o momento",
                      child: TextApp(
                        text: 'Nenhuma notificação recebida.',
                        color: AppColors.grey500,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Semantics(
                    label: "Lista de notificações",
                    hint:
                        "Arraste para cima ou para baixo para navegar pelas notificações",
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      itemCount:
                          history.length + 1, // +1 para adicionar o botão
                      separatorBuilder: (context, index) =>
                          index < history.length - 1
                          ? Divider(color: AppColors.grey800, height: 1)
                          : const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        if (index == history.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Center(
                              child: Semantics(
                                button: true,
                                label: "Limpar todas as notificações",
                                hint:
                                    "Apaga permanentemente todas as notificações da lista",
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.grey800,
                                    foregroundColor: AppColors.textPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.textPrimary,
                                    size: 24,
                                  ),
                                  label: const TextApp(
                                    text: 'Limpar',
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                  ),
                                  onPressed: vm.clearAll,
                                ),
                              ),
                            ),
                          );
                        }

                        final notification = history[index];
                        return NotificationItem(notification: notification);
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}
