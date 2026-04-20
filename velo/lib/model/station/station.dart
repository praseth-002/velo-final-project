import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/dock/dock.dart';

class Station {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final List<Dock> docks;
  final List<Bike> bikes;

  // Counts are fully derived from source lists.
  int get bikesAvailableCount {
    return bikes.where((bike) => bike.isAvailable).length;
  }

  int get openDocksCount {
    final openSlots = docks.length - bikesAvailableCount;
    return openSlots < 0 ? 0 : openSlots;
  }

  Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.docks,
    required this.bikes,
  });

  Station copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    List<Dock>? docks,
    List<Bike>? bikes,
  }) {
    return Station(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      docks: docks ?? this.docks,
      bikes: bikes ?? this.bikes,
    );
  }
}
