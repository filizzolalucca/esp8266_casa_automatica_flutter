import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final IconData icon;

  const RoomCard({
    super.key,
    required this.roomName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 32),
          const SizedBox(height: 8),
          Text(
            roomName,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
