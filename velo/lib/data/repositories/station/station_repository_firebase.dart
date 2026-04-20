import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/firebase_config.dart';
import '../../dtos/station_dtos.dart';
import '/model/station/station.dart';
import '/model/dock/dock.dart';
import '/model/bike/bike.dart';
import 'station_repository.dart';

class StationRepositoryFirebase implements StationRepository {
  final Uri stationsUri =
      FirebaseConfig.baseUri.replace(path: '/stations.json');
  final Uri docksUri =
      FirebaseConfig.baseUri.replace(path: '/docks.json');
  final Uri bikesUri =
      FirebaseConfig.baseUri.replace(path: '/bikes.json');

  // Optional caching for performance.
  List<Station>? _cachedStations;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(seconds: 30);

  /// Fetch all stations.
  /// Assembles Station objects by loading:
  /// - stations metadata
  /// - all docks grouped by stationId
  /// - all bikes grouped by stationId
  @override
  Future<List<Station>> fetchStations() async {
    // Return cache if fresh.
    if (_cachedStations != null && _cacheTime != null) {
      final elapsed = DateTime.now().difference(_cacheTime!);
      if (elapsed < _cacheDuration) {
        return _cachedStations!;
      }
    }

    try {
      // Fetch all three nodes in parallel.
      final stationsResp = await http.get(stationsUri);
      final docksResp = await http.get(docksUri);
      final bikesResp = await http.get(bikesUri);

      if (stationsResp.statusCode != 200 ||
          docksResp.statusCode != 200 ||
          bikesResp.statusCode != 200) {
        throw Exception(
            'Failed to load stations: ${stationsResp.statusCode}, ${docksResp.statusCode}, ${bikesResp.statusCode}');
      }

      // Decode Firebase responses.
      final stationsJson = _parseFirebaseJson(stationsResp.body);
      final docksJson = _parseFirebaseJson(docksResp.body);
      final bikesJson = _parseFirebaseJson(bikesResp.body);

      // Debug logging
      print('[Firebase] stationsJson type: ${stationsJson.runtimeType}, keys: ${stationsJson.keys}');
      print('[Firebase] docksJson type: ${docksJson.runtimeType}, keys: ${docksJson.keys}');
      print('[Firebase] bikesJson type: ${bikesJson.runtimeType}, keys: ${bikesJson.keys}');

      // Build Station objects.
      final stations = <Station>[];
      for (final entry in stationsJson.entries) {
        final stationId = entry.key;
        final stationData = entry.value;

        // Ensure stationData is a map
        if (stationData is! Map<String, dynamic>) {
          print('[Firebase] Warning: station data for $stationId is not a map, skipping');
          continue;
        }

        // Parse station metadata.
        final stationDto = StationDto.fromJson(stationId, stationData);

        // Load docks for this station.
        final stationDocks = <Dock>[];
        if (docksJson.containsKey(stationId)) {
          final docksForStation = docksJson[stationId];
          if (docksForStation is Map<String, dynamic>) {
            for (final dockEntry in docksForStation.entries) {
              final dockDto =
                  DockDto.fromJson(dockEntry.key, dockEntry.value);
              stationDocks.add(dockDto.toDomain());
            }
          }
        }

        // Load bikes for this station.
        final stationBikes = <Bike>[];
        for (final bikeEntry in bikesJson.entries) {
          final bikeId = bikeEntry.key;
          final bikeData = bikeEntry.value;

          if (bikeData is! Map<String, dynamic>) {
            continue;
          }

          final bikeDto = BikeDto.fromJson(bikeId, bikeData);

          // Only include bikes belonging to this station.
          if (bikeDto.stationId == stationId) {
            stationBikes.add(bikeDto.toDomain());
          }
        }

        // Assemble Station.
        final station = Station(
          id: stationDto.id,
          name: stationDto.name,
          latitude: stationDto.latitude,
          longitude: stationDto.longitude,
          address: stationDto.address,
          docks: stationDocks,
          bikes: stationBikes,
        );

        stations.add(station);
      }

      print('[Firebase] Loaded ${stations.length} stations');
      _cachedStations = stations;
      _cacheTime = DateTime.now();
      return stations;
    } catch (e) {
      print('[Firebase] Error: $e');
      throw Exception('Failed to fetch stations: $e');
    }
  }

  /// Fetch a single station by ID.
  @override
  Future<Station> fetchStationById(String id) async {
    final stations = await fetchStations();
    final station = stations.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Station $id not found'),
    );
    return station;
  }

  /// Book a bike at a station.
  /// Updates bike status to checkedOut and returns updated station.
  @override
  Future<Station> bookBike({
    required String stationId,
    required String bikeId,
    required String dockId,
  }) async {
    try {
      // Fetch current bike state.
      final Uri bikeUri = FirebaseConfig.baseUri.replace(
        path: '/bikes/$bikeId.json',
      );

      final bikeResp = await http.get(bikeUri);
      if (bikeResp.statusCode != 200) {
        throw Exception('Bike $bikeId not found');
      }

      final bikeData = json.decode(bikeResp.body) as Map<String, dynamic>?;
      if (bikeData == null) {
        throw Exception('Bike $bikeId data is null');
      }

      final bikeDto = BikeDto.fromJson(bikeId, bikeData);

      // Validate bike is available and matches expected dock/station.
      if (bikeDto.status != BikeStatus.available) {
        throw Exception('Bike $bikeId is not available');
      }
      if (bikeDto.stationId != stationId || bikeDto.dockId != dockId) {
        throw Exception(
            'Bike $bikeId is not at station $stationId dock $dockId');
      }

      // Update bike status to checkedOut.
      final updatedBikeData = bikeDto.copyWith(
        status: BikeStatus.checkedOut,
      ).toJson();

      final updateResp = await http.patch(
        bikeUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedBikeData),
      );

      if (updateResp.statusCode != 200) {
        throw Exception('Failed to update bike $bikeId status');
      }

      // Invalidate cache so next fetch gets fresh data.
      _cachedStations = null;
      _cacheTime = null;

      // Fetch and return updated station.
      return await fetchStationById(stationId);
    } catch (e) {
      throw Exception('Failed to book bike: $e');
    }
  }

  /// Helper to parse Firebase REST API response.
  /// Firebase may return either a Map (object) or List (array).
  /// If it's an array, converts it to a map using array indices as keys.
  Map<String, dynamic> _parseFirebaseJson(String responseBody) {
    final body = json.decode(responseBody);
    if (body == null) {
      print('[Firebase] Response body is null, returning empty map');
      return {};
    }
    
    if (body is Map<String, dynamic>) {
      return body;
    } else if (body is List) {
      // Firebase imported array format: [null, {station 1}, {station 2}, ...]
      // Convert to map: {"1": {station 1}, "2": {station 2}, ...}
      final resultMap = <String, dynamic>{};
      for (int i = 0; i < body.length; i++) {
        if (body[i] != null) {
          resultMap[i.toString()] = body[i];
        }
      }
      print('[Firebase] Converted array to map with keys: ${resultMap.keys.toList()}');
      return resultMap;
    } else {
      print('[Firebase] Warning: unexpected type ${body.runtimeType}. Returning empty map.');
      return {};
    }
  }
}

/// Extension on BikeDto to support copyWith.
extension BikeDtoCopyWith on BikeDto {
  BikeDto copyWith({
    String? id,
    String? stationId,
    String? dockId,
    BikeStatus? status,
  }) {
    return BikeDto(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      dockId: dockId ?? this.dockId,
      status: status ?? this.status,
    );
  }
}
