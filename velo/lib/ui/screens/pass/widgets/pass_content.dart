import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../../ui/screens/pass/widgets/active_pass_view.dart';
import '../../../../ui/screens/pass/widgets/plans_view.dart';
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
        return ActivePassView(vm: vm);
      case PassScreenMode.browsing:
        return PlansView(vm: vm, isSwitching: false);
    }
  }
}
