import 'package:flutter/material.dart';
import '../../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../../ui/screens/pass/widgets/pass_buttons.dart';
import '../../../../ui/screens/pass/widgets/pass_chips.dart';
import '../../../../ui/screens/pass/widgets/subscription_success_dialog.dart';
import '../../../../ui/theme/theme.dart';

class PlanCard extends StatelessWidget {
  final PassViewModel vm;
  final PassType type;
  final bool isSwitching;

  const PlanCard({
    super.key,
    required this.vm,
    required this.type,
    required this.isSwitching,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = vm.isExpanded(type);
    final isCurrent = vm.isCurrentPass(type);
    final badge = vm.badgeFor(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? AppColors.primary
              : isExpanded
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.cardBorder,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => vm.toggleExpanded(type),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              vm.displayNameFor(type),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isCurrent
                                    ? AppColors.primary
                                    : AppColors.textDark,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              const PassCurrentChip(),
                            ] else if (badge != null) ...[
                              const SizedBox(width: 8),
                              PassBadgeChip(label: badge, type: type),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vm.priceLabelFor(type),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        vm.priceSuffixFor(type),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1, color: AppColors.cardBorder),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vm.descriptionFor(type),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMedium,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...vm.featuresFor(type).map(
                              (f) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      f,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (!isCurrent)
                              PassPrimaryButton(
                                label: isSwitching
                                    ? 'Switch to ${vm.displayNameFor(type)}'
                                    : 'Select ${vm.displayNameFor(type)}',
                                onPressed: vm.purchaseStatus ==
                                        PurchaseStatus.loading
                                    ? null
                                    : () => _onTapButton(context, vm, type),
                                isLoading:
                                    vm.purchaseStatus == PurchaseStatus.loading,
                                height: 48,
                                fontSize: 14,
                                borderRadius: 12,
                              )
                            else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'This is your current plan',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapButton(
    BuildContext context,
    PassViewModel vm,
    PassType type,
  ) async {
    if (isSwitching) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Switch Pass?'),
          content: Text(
            'Your current pass will be cancelled and replaced with a ${vm.displayNameFor(type)}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep Current'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Switch',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    final success = await vm.purchasePass(type);
    if (!context.mounted) return;

    if (success) {
      vm.clearAllExpanded();
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => SubscriptionSuccessDialog(
          actionLabel: 'Select ${vm.displayNameFor(type)}',
          onActionTap: () => Navigator.of(dialogContext).pop(),
        ),
      );
      if (!context.mounted) return;
      if (isSwitching && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}
