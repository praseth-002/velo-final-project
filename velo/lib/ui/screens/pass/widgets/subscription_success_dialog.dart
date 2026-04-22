import 'package:flutter/material.dart';
import '../../../../ui/screens/pass/widgets/pass_buttons.dart';
import '../../../../ui/theme/theme.dart';

class SubscriptionSuccessDialog extends StatelessWidget {
  final String actionLabel;
  final VoidCallback onActionTap;

  const SubscriptionSuccessDialog({
    super.key,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 42),
            ),
            const SizedBox(height: 20),
            const Text(
              'Subscription Success',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you',
              style: TextStyle(fontSize: 21, color: AppColors.textMedium),
            ),
            const SizedBox(height: 22),
            PassPrimaryButton(
              label: 'View pass',
              onPressed: onActionTap,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
