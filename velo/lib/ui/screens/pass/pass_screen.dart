import 'package:flutter/material.dart';

class PassScreen extends StatelessWidget {
  const PassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Passes')),
      body: const Center(child: Text('Pass coming soon!')),
    );
  }
}