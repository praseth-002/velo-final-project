import 'package:flutter/foundation.dart';
import '../../data/repositories/pass/pass_repository.dart';
import '../../model/pass/pass.dart';

enum PassStateStatus { idle, loading, error }

class PassState extends ChangeNotifier {
  PassState({required this.repository}) {
    _init();
  }

  final PassRepository repository;

  Pass? _activePass;
  PassStateStatus _status = PassStateStatus.idle;
  String? _errorMessage;

  Pass? get activePass => _activePass;
  PassStateStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == PassStateStatus.loading;
  bool get hasError => _status == PassStateStatus.error;

  /// True when there is a pass and it has not expired.
  bool get hasActivePass => _activePass != null && _activePass!.isActive;


  Future<void> _init() async {
    _setLoading();
    try {
      final passes = await repository.getPasses();
      // Only one active pass allowed; pick the first non-expired one
      _activePass = passes.where((p) => p.isActive).isNotEmpty
          ? passes.where((p) => p.isActive).first
          : null;
      _setIdle();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> refresh() => _init();

  Future<void> purchasePass(PassType type) async {
    _setLoading();
    try {
      final pass = await repository.purchasePass(type);
      _activePass = pass;
      _setIdle();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> cancelActivePass() async {
    final id = _activePass?.id;
    if (id == null) return;

    _setLoading();
    try {
      await repository.cancelPass(id);
      _activePass = null;
      _setIdle();
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading() {
    _status = PassStateStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setIdle() {
    _status = PassStateStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String msg) {
    _status = PassStateStatus.error;
    _errorMessage = msg;
    notifyListeners();
  }
}