import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/dock/dock.dart';
import 'package:velo/model/station/station.dart';

class StationRepositoryMock implements StationRepository {
  final List<Station> _stations = [
    Station(
      id: "1",
      name: "Central Market",
      latitude: 11.569626453704016,
      longitude: 104.92098053806961,
      address: 'Calmette St. 53, Daun Penh District, Phnom Penh 55555',
      docks: _buildDocks(stationId: '1', total: 15),
      bikes: _buildBikes(stationId: '1', bikes: 5),
    ),
    Station(
      id: "2",
      name: "Wat Phnom",
      latitude: 11.57640856103155,
      longitude: 104.923113622726,
      address: 'No. 5 Rd, Phnom Penh',
      docks: _buildDocks(stationId: '2', total: 18),
      bikes: _buildBikes(stationId: '2', bikes: 10),
    ),
    Station(
      id: "3",
      name: "Riverside",
      latitude: 11.571651079548452,
      longitude: 104.92946301852798,
      address: 'No 11 Street 78, Sangkat Tonle Bassac',
      docks: _buildDocks(stationId: '3', total: 8),
      bikes: _buildBikes(stationId: '3', bikes: 6),
    ),
    Station(
      id: "4",
      name: "Independence Monument",
      latitude: 11.556833819255305,
      longitude: 104.92851483198262,
      address: 'Norodom Blvd, 41, Phnom Penh',
      docks: _buildDocks(stationId: '4', total: 7),
      bikes: _buildBikes(stationId: '4', bikes: 4),
    ),
  ];

  @override
  Future<Station> bookBike({
    required String stationId,
    required String bikeId,
    required String dockId,
  }) async {
    return Future.delayed(const Duration(seconds: 1), () {
      final index = _stations.indexWhere((s) => s.id == stationId);
      if (index == -1) throw Exception('Station $stationId not found');

      final station = _stations[index];
      final dockIndex = station.docks.indexWhere((d) => d.id == dockId);
      if (dockIndex == -1) throw Exception('Dock $dockId not found');

      final bikeIndex = station.bikes.indexWhere(
        (b) => b.id == bikeId && b.dockId == dockId && b.isAvailable,
      );
      if (bikeIndex == -1) {
        throw Exception('Bike $bikeId not available at dock $dockId');
      }

      final updatedBikes = List<Bike>.from(station.bikes);
      updatedBikes[bikeIndex] = updatedBikes[bikeIndex].copyWith(
        status: BikeStatus.checkedOut,
      );

      final updated = station.copyWith(
        bikes: updatedBikes,
      );
      _stations[index] = updated;
      return updated;
    });
  }

  @override
  Future<Station> fetchStationById(String id) async {
    return _stations.firstWhere((s) => s.id == id);
  }

  @override
  Future<List<Station>> fetchStations() {
    return Future.delayed(const Duration(milliseconds: 400), () => _stations);
  }

  static List<Dock> _buildDocks({
    required String stationId,
    required int total,
  }) {
    return List.generate(total, (index) {
      return Dock(
        id: '$stationId-dock-${index + 1}',
        label: 'Dock ${index + 1}',
      );
    });
  }

  static List<Bike> _buildBikes({
    required String stationId,
    required int bikes,
  }) {
    return List.generate(bikes, (index) {
      final dockId = '$stationId-dock-${index + 1}';
      return Bike(
        id: '$stationId-bike-${index + 1}',
        status: BikeStatus.available,
        dockId: dockId,
      );
    });
  }
}
