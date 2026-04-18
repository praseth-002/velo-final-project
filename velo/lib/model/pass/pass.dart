enum PassType { day, monthly, yearly }

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

  Duration get remaining => endDate.difference(DateTime.now());

  Pass copyWith({PassType? type, DateTime? startDate, DateTime? endDate}) {
    return Pass(
      id: id,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
