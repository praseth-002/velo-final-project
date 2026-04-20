import 'package:flutter/material.dart';
import '../../../../ui/theme/theme.dart';

class ActivePassCard extends StatelessWidget {
  final String displayName;
  final String priceLabel;
  final String priceSuffix;
  final String activeUntilLabel;
  final String daysRemainingLabel;
  final double progressFraction;

  const ActivePassCard({
    super.key,
    required this.displayName,
    required this.priceLabel,
    required this.priceSuffix,
    required this.activeUntilLabel,
    required this.daysRemainingLabel,
    required this.progressFraction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: name, price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(priceLabel,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  Text(priceSuffix,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(activeUntilLabel,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 18),
          // Progress row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Days remaining',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              Text(daysRemainingLabel,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressFraction,
              backgroundColor: Colors.white30,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}