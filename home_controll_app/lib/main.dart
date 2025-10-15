import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:home_controll_app/modules/home/view_model/home_viewModel.dart';
import 'package:home_controll_app/modules/home/views/home_screen.dart';
import 'package:home_controll_app/modules/settings/view_model/security_view_model.dart';
import 'package:home_controll_app/modules/settings/views/config_screen.dart';
import 'package:home_controll_app/services/notification_service.dart';
import 'package:provider/provider.dart';

import 'utils/injection_container.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();
  await GetIt.I<NotificationService>().init();          
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),

        ChangeNotifierProvider.value(
          value: getIt<SecurityViewModel>(), // pega a instância do GetIt
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Casa Inteligente',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/config': (context) => const ConfigScreen(),
          // Adicione '/notifications' se tiver a tela
        },
      ),
    );
  }
}
