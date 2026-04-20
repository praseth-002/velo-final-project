import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/dock/dock.dart';

class Station {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int availableBikes;
  final int availableDocks;
  final String address;
  final List<Dock> docks;
  final List<Bike> bikes;

  // Derived counts are source-of-truth for station details/map overlays.
  // Fallback to stored values when list data is unavailable.
  int get bikesAvailableCount {
    if (bikes.isEmpty) return availableBikes;
    return bikes.where((bike) => bike.isAvailable).length;
  }

  int get openDocksCount {
    if (docks.isEmpty) return availableDocks;
    return docks.where((dock) => dock.status == DockStatus.occupied).length;
  }

  Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.availableBikes,
    required this.availableDocks,
    required this.address,
    required this.docks,
    required this.bikes,
  });

  Station copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    int? availableBikes,
    int? availableDocks,
    String? address,
    List<Dock>? docks,
    List<Bike>? bikes,
  }) {
    return Station(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      availableBikes: availableBikes ?? this.availableBikes,
      availableDocks: availableDocks ?? this.availableDocks,
      address: address ?? this.address,
      docks: docks ?? this.docks,
      bikes: bikes ?? this.bikes,
    );
  }
}
