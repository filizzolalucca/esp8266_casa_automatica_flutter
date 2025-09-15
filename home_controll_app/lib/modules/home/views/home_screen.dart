import 'package:flutter/material.dart';
import 'package:home_controll_app/modules/home/view_model/home_viewModel.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Casa Inteligente'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // depois vai para a tela de configurações
                  Navigator.pushNamed(context, '/config');
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // --- GRÁFICOS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGauge(
                      title: 'Temperatura',
                      value: vm.data.temperature,
                      max: 50,
                      unit: '°C',
                      color: Colors.orange,
                    ),
                    _buildGauge(
                      title: 'Umidade',
                      value: vm.data.humidity,
                      max: 100,
                      unit: '%',
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- QUARTOS ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quartos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vm.rooms.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final room = vm.rooms[i];
                      return Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            room.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGauge({
    required String title,
    required double value,
    required double max,
    required String unit,
    required Color color,
  }) {
    return SizedBox(
      height: 180,
      width: 150,
      child: Column(
        children: [
          Expanded(
            child: SfRadialGauge(
              axes: [
                RadialAxis(
                  minimum: 0,
                  maximum: max,
                  startAngle: 180,
                  endAngle: 0,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.15,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Colors.grey.shade300,
                  ),
                  pointers: [
                    RangePointer(
                      value: value,
                      width: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: color,
                    ),
                  ],
                  annotations: [
                    GaugeAnnotation(
                      widget: Text(
                        '${value.toStringAsFixed(1)} $unit',
                        style: const TextStyle(fontSize: 16),
                      ),
                      positionFactor: 0.1,
                      angle: 90,
                    )
                  ],
                ),
              ],
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}
