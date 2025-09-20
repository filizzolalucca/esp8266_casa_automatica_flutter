import 'package:flutter/material.dart';
import 'package:home_controll_app/components/room_card.dart';
import 'package:home_controll_app/components/sensor_card.dart';
import 'package:home_controll_app/modules/home/view_model/home_viewModel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF1B1B19),
          body: CustomScrollView(
            slivers: [
              // --- AppBar fixa ---
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFF292826),
                elevation: 0,
                centerTitle: true,
                title: const Text('Meus cômodOOOos'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => Navigator.pushNamed(context, '/config'),
                  ),
                ],
              ),

              // --- Sensor Cards Grid ---
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 por linha
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1, // quadrado
                  ),
                  delegate: SliverChildListDelegate([
                    SensorCard(
                      title: "Temperatura",
                      icon: Icons.thermostat,
                      value: vm.data.temperature,
                      unit: '°C',
                      max: 50,
                    ),
                    SensorCard(
                      title: "Umidade",
                      icon: Icons.water_drop,
                      value: vm.data.humidity,
                      unit: '%',
                      useGradient: false,
                      max: 100,
                      solidColor: Colors.cyan,
                    ),
                  ]),
                ),
              ),

              // --- Divider ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    height: 2,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              // --- Room Cards Grid ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final room = vm.rooms[i];
                      return GestureDetector(
                        onTap: () => print('Quarto clicado: ${room.id}'),
                        child: RoomCard(room: room),
                      );
                    },
                    childCount: vm.rooms.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
