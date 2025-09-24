import 'package:flutter/material.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/utils/color_pallete.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onSettingsPressed;
  final IconData notificationsIcon;
  final IconData settingsIcon;
  final String title;

  const CustomHomeAppBar({
    super.key,
    this.onNotificationsPressed,
    this.onSettingsPressed,
    this.notificationsIcon = Icons.notifications_outlined,
    this.settingsIcon = Icons.settings_outlined,
    this.title = "Meus cômodos",
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: TextApp(text: title, fontSize: 20,),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(notificationsIcon, color: AppColors.icon, size: 36,),
        onPressed: onNotificationsPressed ?? () {
          Navigator.pushNamed(context, '/notifications');
        },
      ),
      actions: [
        IconButton(
          icon: Icon(settingsIcon, color: AppColors.icon, size: 36,),
          onPressed: onSettingsPressed ?? () {
            Navigator.pushNamed(context, '/config');
          },
        ),
      ],
    );
  }
}