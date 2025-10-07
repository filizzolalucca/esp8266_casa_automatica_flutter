import 'package:flutter/material.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/utils/color_pallete.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: title,
      hint: value ? "Ativado" : "Desativado",
      toggled: value,
      child: SwitchListTile(
        title: TextApp(
          text: title,
          fontSize: 16,
          color: Colors.white,
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.icon, // mantém padrão do app
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
