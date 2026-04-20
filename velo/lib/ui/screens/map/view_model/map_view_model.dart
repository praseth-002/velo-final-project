import 'package:flutter/cupertino.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/model/station/station.dart';

class StationViewModel extends ChangeNotifier {
  final StationRepository repository;
  StationViewModel(this.repository);

  List<Station> _stations = [];
  List<Station> get stations => _stations;

  Station? _selectedStation;
  Station? get selectedStation => _selectedStation;
  // bool get loading => _loading;
  // String? get error => _error;
  void selectStation(Station station) {
    _selectedStation = station;
    notifyListeners();
  }

  void clearSelectStation() {
    _selectedStation = null;
    notifyListeners();
  }

  Future<void> loadStations() async {
    _stations = await repository.fetchStations();
    notifyListeners();
  }
}