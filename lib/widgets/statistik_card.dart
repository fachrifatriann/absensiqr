import 'package:flutter/material.dart';

class StatistikCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatistikCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.15), // Memperbaiki warning dengan sintaks Flutter terbaru
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // Memperbaiki typo TolongWarna
              ),
            ],
          ),
        ),
      ),
    );
  }
}