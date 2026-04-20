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
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Pass> purchasePass(PassType type) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final pass = Pass(
      id: Random().nextInt(100000).toString(),
      type: type,
      startDate: now,
      endDate: now.add(type.duration),
    );
    _passes.add(pass);
    return pass;
  }

  @override
  Future<void> cancelPass(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _passes.removeWhere((p) => p.id == id);
  }
}