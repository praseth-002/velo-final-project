import 'package:velo/model/station/station.dart';

abstract class StationRepository {
  Future<List<Station>> fetchStations();
  Future<Station> fetchStationById(String id);
  Future<Station> bookBike({required String stationId, required String bikeId, required String dockId});
}
