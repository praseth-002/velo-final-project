import 'package:flutter/material.dart';
import '../../../../model/pass/pass.dart';
import '../../../../ui/theme/theme.dart';

class PassOptionCard extends StatelessWidget {
  final PassType type;
  final String displayName;
  final String description;
  final String priceLabel;
  final String priceSuffix;
  final bool isSelected;
  final VoidCallback onTap;

  const PassOptionCard({
    super.key,
    required this.type,
    required this.displayName,
    required this.description,
    required this.priceLabel,
    required this.priceSuffix,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconFor(type),
                color: isSelected ? AppColors.primary : AppColors.textMedium,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  priceLabel,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.primary : AppColors.textDark,
                  ),
                ),
                Text(
                  priceSuffix,
                  style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.disabled,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(PassType t) {
    switch (t) {
      case PassType.day:
        return Icons.wb_sunny_outlined;
      case PassType.monthly:
        return Icons.calendar_month_outlined;
      case PassType.annual:
        return Icons.star_outline;
    }
  }
}