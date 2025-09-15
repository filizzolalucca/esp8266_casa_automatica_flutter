import 'package:flutter/material.dart';
import 'package:home_controll_app/modules/home/view_model/home_viewModel.dart';
import 'package:home_controll_app/modules/home/views/home_screen.dart';
import 'package:provider/provider.dart';

import 'utils/injection_container.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();          
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: const MaterialApp(
        title: 'Casa Inteligente',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
