import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../ui/screens/pass/widgets/plan_card.dart';
import 'widgets/pass_error.dart';
import '../../../ui/theme/theme.dart';

class ExplorePassScreen extends StatefulWidget {
  const ExplorePassScreen({super.key});

  @override
  State<ExplorePassScreen> createState() => _ExplorePassScreenState();
}

class _ExplorePassScreenState extends State<ExplorePassScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PassViewModel>().clearAllExpanded();
    });
  }

  @override
  void dispose() {
    context.read<PassViewModel>().clearAllExpanded();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PassViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Explore Plans'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Plans', style: AppTextStyles.heading),
            const SizedBox(height: 6),
            const Text(
              'Your current plan is highlighted. Switch anytime.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 20),

            if (vm.purchaseStatus == PurchaseStatus.error)
              PassErrorBanner(
                message: vm.purchaseError ?? 'Something went wrong.',
                onDismiss: vm.resetPurchaseStatus,
              ),

            ...PassType.values.map(
              (type) => PlanCard(vm: vm, type: type, isSwitching: true),
            ),
          ],
        ),
      ),
    );
  }
}

