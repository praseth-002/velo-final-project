enum DockStatus { available, occupied }

class Dock {
  final String id;
  final String label;
  final DockStatus status;

  Dock({
    required this.id,
    required this.label,
    required this.status,
  });

  bool get isAvailable => status == DockStatus.available;

  Dock copyWith({DockStatus? status}) {
    return Dock(
      id: id,
      label: label,
      status: status ?? this.status,
    );
  }
}