import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double value;
  final String unit;
  final double max;
  final bool useGradient;
  final Color solidColor;

  const SensorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.unit,
    required this.max,
    this.useGradient = true,
    this.solidColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Ícone + texto em linha
            Row(
              children: [
                Icon(icon, color: Colors.white70, size: 22),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🔹 Gauge embaixo
            Expanded(
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: max,
                    startAngle: 180,
                    endAngle: 0,
                    showTicks: false,
                    showLabels: false,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.15,
                      thicknessUnit: GaugeSizeUnit.factor,
                      color: Colors.grey.shade800,
                    ),
                    pointers: [
                      RangePointer(
                        value: value,
                        width: 0.15,
                        sizeUnit: GaugeSizeUnit.factor,
                        gradient: useGradient
                            ? const SweepGradient(
                                colors: [Colors.blue, Colors.green, Colors.orange],
                              )
                            : null,
                        color: useGradient ? null : solidColor,
                      ),
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: Text(
                          '${value.toStringAsFixed(0)}$unit',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        positionFactor: 0.1,
                        angle: 90,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
