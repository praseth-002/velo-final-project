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
  List<Station> _searchResults = [];
  List<Station> get searchResults => _searchResults;


  Future<void> loadStations() async {
    _stations = await repository.fetchStations();
    notifyListeners();
  }

  void searchStation(String query) {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _searchResults = _stations
        .where((s) => s.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    notifyListeners();
  }

  void selectStation(Station station) {
    _selectedStation = station;
    _searchResults = [];
    notifyListeners();
    return;
  }

  void clearSelectedStation() {
    _selectedStation = null;
    notifyListeners();
  }
  void selectFirstResult() {
  if (_searchResults.isEmpty) return;

  final station = _searchResults.first;
  selectStation(station);

  _searchResults = [];
  notifyListeners();
}
}
