import 'package:flutter/material.dart';
import '../../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../../ui/screens/pass/widgets/pass_error.dart';
import '../../../../ui/screens/pass/widgets/plan_card.dart';
import '../../../../ui/theme/theme.dart';

class PlansView extends StatelessWidget {
  final PassViewModel vm;
  final bool isSwitching;
  const PlansView({super.key, required this.vm, required this.isSwitching});

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
