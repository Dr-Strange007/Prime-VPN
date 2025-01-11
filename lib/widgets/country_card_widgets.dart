import 'package:flutter/material.dart';

class CountrySpeedCard extends StatelessWidget {
  final String countryName;
  final String flagAsset;
  final String speed;
  final Color networkIconColor;

  const CountrySpeedCard({
    super.key,
    required this.countryName,
    required this.flagAsset,
    required this.speed,
    this.networkIconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      color: const Color(0xFFF6F6F6),
      child: SizedBox(
        height: 80,
        child: Center(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(flagAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(countryName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(speed, style: const TextStyle(color: Colors.blue)),
                const SizedBox(width: 8),
                Transform.translate(
                  offset: const Offset(0, -3), // Move the icon 2 pixels up
                  child: Icon(Icons.network_cell, color: networkIconColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: VerticalDivider(
                    width: 10,
                    thickness: 1,
                    color: Color(0xFF787473),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
