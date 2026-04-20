import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/dock/dock.dart';

/// DTO for Station metadata (name, location, address).
class StationDto {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  StationDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  /// Convert Firebase JSON node to StationDto.
  factory StationDto.fromJson(String id, Map<String, dynamic> json) {
    return StationDto(
      id: id,
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
    );
  }

  /// Convert StationDto to Firebase JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

/// DTO for Dock metadata (label).
class DockDto {
  final String id;
  final String label;

  DockDto({
    required this.id,
    required this.label,
  });

  /// Convert Firebase JSON node to DockDto.
  factory DockDto.fromJson(String id, Map<String, dynamic> json) {
    return DockDto(
      id: id,
      label: json['label'] ?? '',
    );
  }

  /// Convert DockDto to Firebase JSON.
  Map<String, dynamic> toJson() {
    return {
      'label': label,
    };
  }

  /// Convert DockDto to domain model Dock.
  Dock toDomain() {
    return Dock(id: id, label: label);
  }
}

/// DTO for Bike state (stationId, dockId, status).
class BikeDto {
  final String id;
  final String stationId;
  final String dockId;
  final BikeStatus status;

  BikeDto({
    required this.id,
    required this.stationId,
    required this.dockId,
    required this.status,
  });

  /// Convert Firebase JSON node to BikeDto.
  factory BikeDto.fromJson(String id, Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'available';
    return BikeDto(
      id: id,
      stationId: json['stationId'] ?? '',
      dockId: json['dockId'] ?? '',
      status: statusStr == 'checkedOut' ? BikeStatus.checkedOut : BikeStatus.available,
    );
  }

  /// Convert BikeDto to Firebase JSON.
  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'dockId': dockId,
      'status': status == BikeStatus.checkedOut ? 'checkedOut' : 'available',
    };
  }

  /// Convert BikeDto to domain model Bike.
  Bike toDomain() {
    return Bike(id: id, status: status, dockId: dockId);
  }
}
