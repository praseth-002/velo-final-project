import 'package:flutter/material.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/station/station.dart';
import '../../../../model/dock/dock.dart';
import '../../../../ui/state/pass_state.dart';
// import '../../../../ui/utils/async_value.dart';

enum BookingStatus { idle, loading, success, error }

class StationDetailsViewModel extends ChangeNotifier {
  final StationRepository stationRepository;
  final PassState passState;

  Station station;

  // Selected dock (null = nothing selected)
  Dock? selectedDock;

  // Booking lifecycle
  BookingStatus bookingStatus = BookingStatus.idle;
  String? bookingError;

  StationDetailsViewModel({
    required this.station,
    required this.stationRepository,
    required this.passState,
  }) {
    // Re-notify our listeners whenever the global pass changes
    // so the UI reacts (banner appears/disappears, button enables)
    passState.addListener(_onPassChanged);
  }

  @override
  void dispose() {
    passState.removeListener(_onPassChanged);
    super.dispose();
  }

  // ─── Derived getters ──────────────────────────────────────────────────────

  bool get hasActivePass => passState.hasActivePass;

  bool get usesOneTimeFee => !hasActivePass;

  bool get canBook =>
      selectedDock != null &&
      bookingStatus != BookingStatus.loading;

  List<Dock> get docksWithAvailableBikes {
    return station.docks.where((dock) {
      return station.bikes.any(
        (bike) => bike.dockId == dock.id && bike.status == BikeStatus.available,
      );
    }).toList();
  }

  Bike? availableBikeForDock(Dock dock) {
    for (final bike in station.bikes) {
      if (bike.dockId == dock.id && bike.status == BikeStatus.available) {
        return bike;
      }
    }
    return null;
  }

  void updateStation(Station updatedStation) {
    station = updatedStation;
    selectedDock = null;
    notifyListeners();
  }

  Future<void> refreshStation() async {
    station = await stationRepository.fetchStationById(station.id);
    selectedDock = null;
    notifyListeners();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void selectDock(Dock dock) {
    if (availableBikeForDock(dock) == null) return;

    selectedDock = selectedDock?.id == dock.id ? null : dock;
    notifyListeners();
  }

  Future<void> bookBike() async {
    if (!canBook) return;

    bookingStatus = BookingStatus.loading;
    bookingError = null;
    notifyListeners();

    try {
      Bike? selectedBike;
      for (final bike in station.bikes) {
        if (bike.dockId == selectedDock!.id && bike.status == BikeStatus.available) {
          selectedBike = bike;
          break;
        }
      }
      if (selectedBike == null) {
        throw Exception('No available bike at selected dock');
      }

      final updatedStation = await stationRepository.bookBike(
        stationId: station.id,
        bikeId: selectedBike.id,
        dockId: selectedDock!.id,
      );
      station = updatedStation;
      selectedDock = null;
      bookingStatus = BookingStatus.success;
    } catch (e) {
      bookingStatus = BookingStatus.error;
      bookingError = e.toString();
    }

    notifyListeners();
  }

  void resetBookingStatus() {
    bookingStatus = BookingStatus.idle;
    bookingError = null;
    notifyListeners();
  }

  void _onPassChanged() {
    // Keep current selection; booking label/action adapts to pass state.
    notifyListeners();
  }
}

