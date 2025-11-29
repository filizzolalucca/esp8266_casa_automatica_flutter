import 'package:flutter/material.dart';
import 'package:home_controll_app/components/text_app.dart';
import 'package:home_controll_app/modules/home/models/room_item.dart';
import 'package:home_controll_app/utils/color_pallete.dart';

class RoomCard extends StatelessWidget {
  final RoomItem room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(room.icon, color: AppColors.icon, size: 32),
          const SizedBox(height: 8),
          TextApp(text: room.name, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
