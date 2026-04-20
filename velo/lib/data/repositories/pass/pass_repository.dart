import '../../../model/pass/pass.dart';

abstract class PassRepository {
  Future<List<Pass>> getPasses();

  Future<Pass?> getPassById(String id);

  Future<Pass> purchasePass(PassType type);

  Future<void> cancelPass(String id);
}