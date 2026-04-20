import '../../../../model/pass/pass.dart';

extension PassTypePresenter on PassType {
  String get displayName {
    switch (this) {
      case PassType.day:     return 'Day Pass';
      case PassType.monthly: return 'Monthly Pass';
      case PassType.annual:  return 'Annual Pass';
    }
  }

  String get description {
    switch (this) {
      case PassType.day:     return 'Perfect for trying out';
      case PassType.monthly: return 'Best for regular riders';
      case PassType.annual:  return 'Maximum savings';
    }
  }

  /// Bullet-point features shown when a card is expanded.
  List<String> get features {
    switch (this) {
      case PassType.day:
        return ['24-hour access', 'All premium features', 'No commitment'];
      case PassType.monthly:
        return ['30-day access', 'All premium features', 'Save vs daily passes'];
      case PassType.annual:
        return ['365-day access', 'All premium features', 'Best value overall'];
    }
  }

  /// Badge label shown on the card header, or null if none.
  String? get badge {
    switch (this) {
      case PassType.day:     return null;
      case PassType.monthly: return 'Popular';
      case PassType.annual:  return 'Best Value';
    }
  }

  String get priceLabel {
    final p = price;
    return p == p.truncateToDouble()
        ? '\$${p.toInt()}'
        : '\$${p.toStringAsFixed(2)}';
  }

  String get priceSuffix {
    switch (this) {
      case PassType.day:     return 'per day';
      case PassType.monthly: return 'per month';
      case PassType.annual:  return 'per year';
    }
  }
}

extension PassPresenter on Pass {
  String get activeUntilLabel {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return 'Active until ${months[endDate.month]} ${endDate.day}, ${endDate.year}';
  }

  String get daysRemainingLabel {
    final d = daysRemaining;
    return '$d day${d == 1 ? '' : 's'}';
  }
}