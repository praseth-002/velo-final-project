import 'package:velo/data/repositories/station_repository.dart';
import 'package:velo/model/station/station.dart';

class StationRepositoryMock implements StationRepository {
  final List<Station> _stations = [
    Station(
      id: "1",
      name: "Central Market",
      latitude: 11.5762,
      longitude: 104.9227,
      availableBikes: 5,
      availableDocks: 10,
      address: 'Calmette St. 53, Daun Penh District, Phnom Penh 55555'
    ),
    Station(
      id: "2",
      name: "Wat Phnom",
      latitude: 11.5797,
      longitude: 104.9256,
      availableBikes: 10,
      availableDocks: 8,
      address: 'No. 5 Rd, Phnom Penh'
    ),
    Station(
      id: "3",
      name: "Riverside",
      latitude: 11.5628,
      longitude: 104.9310,
      availableBikes: 0,
      availableDocks: 8,
      address: 'No 11 Street 78, Sangkat Tonle Bassac'

    ),
    Station(
      id: "4",
      name: "Independence Monument",
      latitude: 11.5564,
      longitude: 104.9312,
      availableBikes: 0,
      availableDocks: 8,
      address: 'Norodom Blvd, 41, Phnom Penh'
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
      if (station.availableBikes <= 0) {
        throw Exception('No bikes available');
      }

      //test
      final updated = station.copyWith(
        availableBikes: station.availableBikes - 1,
        availableDocks: station.availableDocks + 1,
      );
      return updated;
    });
  }

  @override
  Future<Station> fetchStationById(String id) async {
    return _stations.firstWhere((s) => s.id == id);
  }

  @override
  Future<List<Station>> fetchStations() {
    return Future.delayed(Duration(milliseconds: 400), () => _stations);
  }
}
