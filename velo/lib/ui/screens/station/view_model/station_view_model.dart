import 'package:flutter/material.dart';
import 'package:velo/data/repositories/station_repository.dart';
import 'package:velo/model/station/station.dart';
import '../../../../model/dock/dock.dart';
// import '../../../../ui/utils/async_value.dart';

enum BookingStatus { idle, loading, success, error }

class StationViewModel extends ChangeNotifier {
  final StationRepository stationRepository;
  // final PassState passState;

  Station station;

  // Selected dock (null = nothing selected)
  Dock? selectedDock;

  // Booking lifecycle
  BookingStatus bookingStatus = BookingStatus.idle;
  String? bookingError;

  StationViewModel({
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

  bool get canBook =>
      hasActivePass &&
      selectedDock != null &&
      bookingStatus != BookingStatus.loading;

  List<Dock> get docks => station.docks;

  // ─── Actions ──────────────────────────────────────────────────────────────

  void selectDock(Dock dock) {
    if (!dock.isAvailable) return;
    if (!hasActivePass) return;

    selectedDock = selectedDock?.id == dock.id ? null : dock;
    notifyListeners();
  }

  Future<void> bookBike() async {
    if (!canBook) return;

    bookingStatus = BookingStatus.loading;
    bookingError = null;
    notifyListeners();

    try {
      final updatedStation = await stationRepository.bookBike(
        stationId: station.id,
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
    // If the pass was deactivated, clear any selection
    if (!hasActivePass) selectedDock = null;
    notifyListeners();
  }
}

