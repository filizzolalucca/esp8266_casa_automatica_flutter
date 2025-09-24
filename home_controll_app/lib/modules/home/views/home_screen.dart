import 'package:flutter/material.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/modules/home/models/room_item.dart';
import 'package:home_controll_app/modules/home/models/sensor_data.dart';
import 'package:home_controll_app/utils/color_pallete.dart';
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
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/config'),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 150)),

              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final room = vm.rooms[index];
                      return GestureDetector(
                        onTap: () => _showRoomDialog(context, room, vm),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(thickness: 1, color: Colors.grey.shade700),
                ),
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
                      type: SensorType.temperature,
                      value: vm.data.temperature,
                      unit: "°C",
                      max: 50,
                    ),
                    SensorCard(
                      type: SensorType.humidity,
                      value: vm.data.humidity,
                      unit: "%",
                      max: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRoomDialog(BuildContext context, RoomItem room, HomeViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Consumer<HomeViewModel>(
          builder: (context, vm, child) {
            final isOn = vm.lights[room.feedKey] ?? false;

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: const Color(0xFF2A2A28),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Icon(room.icon, color: Colors.white, size: 48),
                        const SizedBox(height: 12),
                        TextApp(text: room.name),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => vm.toggleLight(room.feedKey),
                      child: Container(
                        height: 64,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isOn ? Colors.blue : Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          color: isOn ? Colors.amber : Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}