import 'package:flutter/material.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/station/station.dart';
import '../../../../model/dock/dock.dart';

class DockBike {
  final Dock dock;
  final Bike bike;

  const DockBike({
    required this.dock,
    required this.bike,
  });
}

class StationDetailsViewModel extends ChangeNotifier {
  final StationRepository stationRepository;

  Station station;

  StationDetailsViewModel({
    required this.station,
    required this.stationRepository,
  });

  // ─── Derived getters ──────────────────────────────────────────────────────

  List<DockBike> get availableDockBikes {
    final availableBikeByDockId = <String, Bike>{};

    for (final bike in station.bikes) {
      if (bike.status == BikeStatus.available &&
          !availableBikeByDockId.containsKey(bike.dockId)) {
        availableBikeByDockId[bike.dockId] = bike;
      }
    }

    final options = <DockBike>[];
    for (final dock in station.docks) {
      final bike = availableBikeByDockId[dock.id];
      if (bike != null) {
        options.add(DockBike(dock: dock, bike: bike));
      }
    }

    return options;
  }

  void updateStation(Station updatedStation) {
    station = updatedStation;
    notifyListeners();
  }

  Future<void> refreshStation() async {
    station = await stationRepository.fetchStationById(station.id);
    notifyListeners();
  }
}

