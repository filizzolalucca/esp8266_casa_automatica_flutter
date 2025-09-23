import 'package:flutter/material.dart';
import 'package:home_controll_app/modules/home/models/room_item.dart';

class RoomCard extends StatelessWidget {
  final RoomItem room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF292826), // fundo do card
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade700, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(room.icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            room.name,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
