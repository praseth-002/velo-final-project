import 'dart:async';
import 'dart:math';
import '../../../model/pass/pass.dart';
import 'pass_repository.dart';

class MockPassRepository implements PassRepository {
  final List<Pass> _passes = [];

  @override
  Future<List<Pass>> getPasses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_passes);
  }

  @override
  Future<Pass?> getPassById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _passes.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> purchasePass(PassType type) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final duration = _getDuration(type);

    final newPass = Pass(
      id: _generateId(),
      type: type,
      startDate: now,
      endDate: now.add(duration),
    );

    _passes.add(newPass);
  }

  @override
  Future<void> cancelPass(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _passes.removeWhere((p) => p.id == id);
  }

  // --- Helpers ---
  Duration _getDuration(PassType type) {
    switch (type) {
      case PassType.day:
        return const Duration(days: 1);
      case PassType.monthly:
        return const Duration(days: 30);
      case PassType.yearly:
        return const Duration(days: 365);
    }
  }

  String _generateId() {
    return Random().nextInt(100000).toString();
  }
}
