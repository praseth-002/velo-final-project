enum PassType { day, monthly, annual }

extension PassTypeExtension on PassType {
  Duration get duration {
    switch (this) {
      case PassType.day:
        return const Duration(days: 1);
      case PassType.monthly:
        return const Duration(days: 30);
      case PassType.annual:
        return const Duration(days: 365);
    }
  }

  // Price of the pass
  double get price {
    switch (this) {
      case PassType.day:
        return 2.99;
      case PassType.monthly:
        return 29.00;
      case PassType.annual:
        return 99.00;
    }
  }
}

class Pass {
  final String id;
  final PassType type;
  final DateTime startDate;
  final DateTime endDate;

  Pass({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  bool get isActive => DateTime.now().isBefore(endDate);

  int get daysRemaining =>
      endDate.difference(DateTime.now()).inDays.clamp(0, type.duration.inDays);

  double get progressFraction {
    final total = type.duration.inDays;
    if (total == 0) return 0;
    return (daysRemaining / total).clamp(0.0, 1.0);
  }

  Pass copyWith({PassType? type, DateTime? startDate, DateTime? endDate}) {
    return Pass(
      id: id,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}