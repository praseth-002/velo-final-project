enum BikeStatus { available, checkedOut }

class Bike {
  final String id;
  final BikeStatus status;
  final String dockId;

  Bike({
    required this.id,
    required this.status,
    required this.dockId,
  });

  bool get isAvailable => status == BikeStatus.available;

  Bike copyWith({BikeStatus? status, String? dockId}) {
    return Bike(
      id: id,
      status: status ?? this.status,
      dockId: dockId ?? this.dockId,
    );
  }
}