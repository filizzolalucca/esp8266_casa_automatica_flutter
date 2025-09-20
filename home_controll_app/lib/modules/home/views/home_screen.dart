import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:home_controll_app/modules/home/view_model/home_viewModel.dart';
import 'package:home_controll_app/components/sensor_card.dart';
import 'package:home_controll_app/components/room_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFF1B1B19),
          appBar: AppBar(
            title: const Text(
              "Meus cômodos", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF292826),
            elevation: 0,
            scrolledUnderElevation: 0, // 👈 impede mudar de cor ao scrollar
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/config');
                },
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
             
              const SliverToBoxAdapter(
                child: SizedBox(height: 150),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    SensorCard(
                      title: "Temperatura",
                      icon: Icons.thermostat,
                      value: vm.data.temperature,
                      unit: "°C",
                      max: 50,
                    ),
                    SensorCard(
                      title: "Umidade",
                      icon: Icons.water_drop,
                      value: vm.data.humidity,
                      unit: "%",
                      max: 100,
                    ),
                  ],
                ),
              ),

               // 🔹 Divider entre sensores e cômodos
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(thickness: 1, color: Colors.grey.shade700),
                ),
              ),

              // 🔹 Grid de Quartos com seu RoomCard
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverGrid(
                 delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final room = vm.rooms[index];
                      return GestureDetector(
                        onTap: () {
                          print('Quarto clicado: ${room.id}');
                          // 👉 aqui você pode chamar Navigator.pushNamed(context, '/detalhes', arguments: room);
                        },
                        child: RoomCard(room: room),
                      );
                    },
                    childCount: vm.rooms.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
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
