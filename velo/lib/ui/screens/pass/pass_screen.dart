import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/screens/pass/widgets/pass_content.dart';
import '../../../ui/screens/pass/view_model/pass_view_model.dart';
import '../../../ui/state/pass_state.dart';

class PassScreen extends StatelessWidget {
  const PassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => PassViewModel(passState: ctx.read<PassState>()),
      child: const PassContent(),
    );
  }
}