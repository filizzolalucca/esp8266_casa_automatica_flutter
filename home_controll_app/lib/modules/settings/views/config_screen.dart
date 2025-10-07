import 'package:flutter/material.dart';
import 'package:home_controll_app/components/app_bar.dart';
import 'package:home_controll_app/modules/settings/components/settings_title.dart';
import 'package:home_controll_app/utils/color_pallete.dart';
import 'package:provider/provider.dart';
import 'package:home_controll_app/modules/settings/view_model/security_view_model.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomBackAppBar(
            title: "Configurações",
            onBackPressed: () => Navigator.of(context).pop(),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SettingTile(
                title: "Modo de Segurança",
                value: vm.modoSeguranca,
                onChanged: vm.toggleSeguranca,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(thickness: 1, color: Colors.grey.shade700),
              ),
              SettingTile(
                title: "Economia de energia",
                value: vm.economiaEnergia,
                onChanged: vm.toggleEconomiaEnergia,
              ),
              // Adicione outros tiles aqui
            ],
          ),
        );
      },
    );
  }
}
