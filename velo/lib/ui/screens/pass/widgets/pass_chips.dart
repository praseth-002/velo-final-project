import 'package:flutter/material.dart';
import '../../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../../ui/theme/theme.dart';

class PassCurrentChip extends StatelessWidget {
  const PassCurrentChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Current',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class PassBadgeChip extends StatelessWidget {
  final String label;
  final PassType type;
  const PassBadgeChip({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    final color = type == PassType.monthly
        ? const Color(0xFF4CAF50)
        : const Color(0xFF9C27B0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
