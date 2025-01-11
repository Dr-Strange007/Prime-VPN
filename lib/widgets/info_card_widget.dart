import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String duration;
  final String dataUsed;
  final String publicIP;

  const InfoCard({super.key, required this.duration, required this.dataUsed, required this.publicIP});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.fromLTRB(36, 20, 36, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7931E),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem(
            icon: Icons.language,
            label: 'France',
            value: publicIP,
          ),
          _infoItem(
            icon: Icons.timer,
            label: 'Duration',
            value: duration,
          ),
          _infoItem(
            icon: Icons.data_usage,
            label: 'Data Used',
            value: dataUsed,
          ),
        ],
      ),
    );
  }

  Widget _infoItem({required IconData icon, required String label, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: const Color(0xFFF7931E)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
