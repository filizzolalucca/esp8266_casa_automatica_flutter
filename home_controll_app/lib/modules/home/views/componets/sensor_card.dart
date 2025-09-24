import 'package:flutter/material.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/modules/home/models/sensor_data.dart';
import 'package:home_controll_app/utils/color_pallete.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class SensorCard extends StatelessWidget {
  final SensorType type;
  final double value;
  final String unit;
  final double max;

  const SensorCard({
    super.key,
    required this.type,
    required this.value,
    required this.unit,
    required this.max,
  });

  SweepGradient _getGradient() {
    switch (type) {
      case SensorType.temperature:
        return const SweepGradient(
          colors: [
            AppColors.temperatureStart,
            AppColors.temperatureMiddle,
            AppColors.temperatureEnd,
          ],
          stops: [0.0, 0.5, 1.0],
        );
      case SensorType.humidity:
        return const SweepGradient(
          colors: [
            AppColors.humidityStart,
            AppColors.humidityMiddle,
            AppColors.humidityEnd,
          ],
          stops: [0.0, 0.5, 1.0],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.black33,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade700, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(type.icon, color: AppColors.icon, size: 25),
                const SizedBox(width: 6),
                TextApp(text: type.displayName),
              ],
            ),
            const SizedBox(height: 8),
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
                      thickness: 0.25,
                      thicknessUnit: GaugeSizeUnit.factor,
                      color: Colors.grey.shade800,
                    ),
                    pointers: [
                      RangePointer(
                        value: value,
                        width: 0.25,
                        sizeUnit: GaugeSizeUnit.factor,
                        gradient: _getGradient(),
                        color: null,
                      ),
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: TextApp(
                          text: '${value.toStringAsFixed(0)}$unit',
                          fontSize: 18,
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