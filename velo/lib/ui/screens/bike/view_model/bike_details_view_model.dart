import 'package:flutter/material.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/dock/dock.dart';
import 'package:velo/model/station/station.dart';
import 'package:velo/ui/state/pass_state.dart';

class BikeDetailsViewModel extends ChangeNotifier {
  BikeDetailsViewModel({
    required this.station,
    required this.dock,
    required this.bike,
    required this.stationRepository,
    required this.passState,
  }) {
    passState.addListener(_onPassChanged);
  }

  final Station station;
  final Dock dock;
  final Bike bike;
  final StationRepository stationRepository;
  final PassState passState;

  bool isBooking = false;
  String? bookingError;

  bool get hasActivePass => passState.hasActivePass;
  bool get usesOneTimeFee => !hasActivePass;

  Future<Station?> bookBike() async {
    if (isBooking) return null;

    isBooking = true;
    bookingError = null;
    notifyListeners();

    try {
      final updatedStation = await stationRepository.bookBike(
        stationId: station.id,
        bikeId: bike.id,
        dockId: dock.id,
      );
      isBooking = false;
      notifyListeners();
      return updatedStation;
    } catch (e) {
      bookingError = e.toString();
      isBooking = false;
      notifyListeners();
      return null;
    }
  }

  void _onPassChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    passState.removeListener(_onPassChanged);
    super.dispose();
  }
}