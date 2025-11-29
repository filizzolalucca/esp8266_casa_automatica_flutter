import 'package:flutter/material.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/utils/color_pallete.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomBackAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
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
      leading: Semantics(
        label: "Voltar",
        hint: "Toque para voltar para home",
        button: true,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.icon, size: 36),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        ),
      ),
      title: Semantics(
        label: title,
        child: TextApp(text: title, fontSize: 20),
      ),
      centerTitle: true,
    );
  }
}
