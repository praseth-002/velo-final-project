import 'package:flutter/foundation.dart';
import '../../../../model/pass/pass.dart';
import '../../../../ui/screens/pass/presenter/pass_presenter.dart';
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


  String get passDisplayName        => _pass?.type.displayName ?? '';
  String get passPriceLabel         => _pass?.type.priceLabel ?? '';
  String get passPriceSuffix        => _pass?.type.priceSuffix ?? '';
  String get passActiveUntilLabel   => _pass?.activeUntilLabel ?? '';
  String get passDaysRemainingLabel => _pass?.daysRemainingLabel ?? '';
  double get passProgressFraction   => _pass?.progressFraction ?? 0.0;

  String displayNameFor(PassType type)    => type.displayName;
  String priceLabelFor(PassType type)     => type.priceLabel;
  String priceSuffixFor(PassType type)    => type.priceSuffix;
  String descriptionFor(PassType type)    => type.description;
  List<String> featuresFor(PassType type) => type.features;
  String? badgeFor(PassType type)         => type.badge;

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