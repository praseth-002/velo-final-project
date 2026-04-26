import 'package:flutter/foundation.dart';
import '../../../../model/pass/pass.dart';
import '../../../../ui/state/pass_state.dart';
export '../../../../model/pass/pass.dart' show PassType;

enum PurchaseStatus { idle, loading, success, error }

enum PassScreenMode {
  browsing,
  activePass,
}

class PassViewModel extends ChangeNotifier {
  PassViewModel({required PassState passState}) : _passState = passState {
    _passState.addListener(_onStateChanged);
  }

  final PassState _passState;

  PurchaseStatus _purchaseStatus = PurchaseStatus.idle;
  String? _purchaseError;

  final Set<PassType> _expandedTypes = {};

  Pass? get _pass => _passState.activePass;

  PassScreenMode get screenMode =>
      _passState.hasActivePass ? PassScreenMode.activePass : PassScreenMode.browsing;

  bool get isInitialising =>
      _passState.isLoading && _purchaseStatus == PurchaseStatus.idle;

  bool isExpanded(PassType type) => _expandedTypes.contains(type);

  void toggleExpanded(PassType type) {
    if (_expandedTypes.contains(type)) {
      _expandedTypes.remove(type);
    } else {
      _expandedTypes.add(type);
    }
    notifyListeners();
  }

  void clearAllExpanded() {
    _expandedTypes.clear();
    notifyListeners();
  }

  PassType? get activePassType => _pass?.type;

  bool isCurrentPass(PassType type) => _pass?.type == type;

  PurchaseStatus get purchaseStatus => _purchaseStatus;
  String? get purchaseError => _purchaseError;

  void resetPurchaseStatus() {
    _purchaseStatus = PurchaseStatus.idle;
    _purchaseError = null;
    notifyListeners();
  }

  // --- Active pass display ---
  String get passDisplayName        => _pass != null ? displayNameFor(_pass!.type) : '';
  String get passPriceLabel         => _pass != null ? priceLabelFor(_pass!.type) : '';
  String get passPriceSuffix        => _pass != null ? priceSuffixFor(_pass!.type) : '';
  String get passActiveUntilLabel   => _pass != null ? _activeUntilLabel(_pass!) : '';
  String get passDaysRemainingLabel => _pass != null ? _daysRemainingLabel(_pass!) : '';
  double get passProgressFraction   => _pass?.progressFraction ?? 0.0;

  // --- Per-type display ---
  String displayNameFor(PassType type) {
    switch (type) {
      case PassType.day:     return 'Day Pass';
      case PassType.monthly: return 'Monthly Pass';
      case PassType.annual:  return 'Annual Pass';
    }
  }

  String descriptionFor(PassType type) {
    switch (type) {
      case PassType.day:     return 'Perfect for trying out';
      case PassType.monthly: return 'Best for regular riders';
      case PassType.annual:  return 'Maximum savings';
    }
  }

  List<String> featuresFor(PassType type) {
    switch (type) {
      case PassType.day:
        return ['24-hour access', 'All premium features', 'No commitment'];
      case PassType.monthly:
        return ['30-day access', 'All premium features', 'Save vs daily passes'];
      case PassType.annual:
        return ['365-day access', 'All premium features', 'Best value overall'];
    }
  }

  String? badgeFor(PassType type) {
    switch (type) {
      case PassType.day:     return null;
      case PassType.monthly: return 'Popular';
      case PassType.annual:  return 'Best Value';
    }
  }

  String priceLabelFor(PassType type) {
    final p = type.price;
    return p == p.truncateToDouble()
        ? '\$${p.toInt()}'
        : '\$${p.toStringAsFixed(2)}';
  }

  String priceSuffixFor(PassType type) {
    switch (type) {
      case PassType.day:     return 'per day';
      case PassType.monthly: return 'per month';
      case PassType.annual:  return 'per year';
    }
  }

  // --- Pass instance display helpers ---
  String _activeUntilLabel(Pass pass) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return 'Active until ${months[pass.endDate.month]} ${pass.endDate.day}, ${pass.endDate.year}';
  }

  String _daysRemainingLabel(Pass pass) {
    final d = pass.daysRemaining;
    return '$d day${d == 1 ? '' : 's'}';
  }

  Future<bool> purchasePass(PassType type) async {
    _purchaseStatus = PurchaseStatus.loading;
    _purchaseError = null;
    notifyListeners();

    if (_passState.hasActivePass) {
      await _passState.cancelActivePass();
    }

    await _passState.purchasePass(type);

    if (_passState.hasError) {
      _purchaseStatus = PurchaseStatus.error;
      _purchaseError = _passState.errorMessage;
      notifyListeners();
      return false;
    }

    _purchaseStatus = PurchaseStatus.idle;
    notifyListeners();
    return true;
  }

  Future<void> cancelPass() async {
    await _passState.cancelActivePass();
    _purchaseStatus = PurchaseStatus.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _passState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() => notifyListeners();
}