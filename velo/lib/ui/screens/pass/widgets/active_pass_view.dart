import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../ui/screens/pass/explore_pass_screen.dart';
import '../../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../../ui/screens/pass/widgets/active_pass_card.dart';
import '../../../../ui/screens/pass/widgets/pass_buttons.dart';
import '../../../../ui/theme/theme.dart';

class ActivePassView extends StatelessWidget {
  final PassViewModel vm;
  const ActivePassView({super.key, required this.vm});

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
