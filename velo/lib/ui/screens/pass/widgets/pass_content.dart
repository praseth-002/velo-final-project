import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../ui/screens/pass/explore_pass_screen.dart';
import '../../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../../ui/screens/pass/widgets/active_pass_card.dart';
import '../../../../ui/screens/pass/widgets/pass_buttons.dart';
import '../../../../ui/screens/pass/widgets/pass_chips.dart';
import 'pass_error.dart';
import '../../../../ui/theme/theme.dart';

class PassContent extends StatefulWidget {
  const PassContent({super.key});

  @override
  State<PassContent> createState() => _PassContentState();
}

class _PassContentState extends State<PassContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PassViewModel>().clearAllExpanded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PassViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('PASS'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: vm.isInitialising
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, PassViewModel vm) {
    switch (vm.screenMode) {
      case PassScreenMode.activePass:
        return _ActivePassView(vm: vm);
      case PassScreenMode.browsing:
        return _PlansView(vm: vm, isSwitching: false);
    }
  }
}

class _ActivePassView extends StatelessWidget {
  final PassViewModel vm;
  const _ActivePassView({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Plan', style: AppTextStyles.heading),
          const SizedBox(height: 16),

          ActivePassCard(
            displayName: vm.passDisplayName,
            priceLabel: vm.passPriceLabel,
            priceSuffix: vm.passPriceSuffix,
            activeUntilLabel: vm.passActiveUntilLabel,
            daysRemainingLabel: vm.passDaysRemainingLabel,
            progressFraction: vm.passProgressFraction,
          ),

          const SizedBox(height: 24),

          PassPrimaryButton(
            label: 'Explore Plans',
            onPressed: () async {
              vm.clearAllExpanded();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: vm,
                    child: const ExplorePassScreen(),
                  ),
                ),
              );
              vm.clearAllExpanded();
            },
          ),

          const SizedBox(height: 12),

          PassDangerButton(
            label: 'Cancel Pass',
            onPressed: () => _confirmCancel(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Pass?'),
        content: const Text(
          'Your pass will be cancelled and you will lose the remaining days.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Pass'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) await vm.cancelPass();
  }
}

class _PlansView extends StatelessWidget {
  final PassViewModel vm;
  final bool isSwitching;
  const _PlansView({required this.vm, required this.isSwitching});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Plans', style: AppTextStyles.heading),
          const SizedBox(height: 16),

          if (vm.purchaseStatus == PurchaseStatus.error)
            PassErrorBanner(
              message: vm.purchaseError ?? 'Something went wrong.',
              onDismiss: vm.resetPurchaseStatus,
            ),

          ...PassType.values.map(
            (type) => PlanCard(vm: vm, type: type, isSwitching: isSwitching),
          ),
        ],
      ),
    );
  }
}

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
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.cardBorder,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // header
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
                                onPressed: vm.purchaseStatus == PurchaseStatus.loading
                                    ? null
                                    : () => _onTapButton(context, vm, type),
                                isLoading: vm.purchaseStatus == PurchaseStatus.loading,
                                height: 48,
                                fontSize: 14,
                                borderRadius: 12,
                              )
                            else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
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
      await _showSubscriptionSuccessDialog(
        context,
        actionLabel: 'Select ${vm.displayNameFor(type)}',
      );
      if (!context.mounted) return;
      if (isSwitching && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _showSubscriptionSuccessDialog(
    BuildContext context, {
    required String actionLabel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _SubscriptionSuccessDialog(
        actionLabel: actionLabel,
        onActionTap: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}

class _SubscriptionSuccessDialog extends StatelessWidget {
  final String actionLabel;
  final VoidCallback onActionTap;

  const _SubscriptionSuccessDialog({
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
