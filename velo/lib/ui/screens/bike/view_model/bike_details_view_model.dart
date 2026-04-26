import 'dart:async';

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
    _scheduleCooldownEndNotification();
  }

  final Station station;
  final Dock dock;
  final Bike bike;
  final StationRepository stationRepository;
  final PassState passState;

  static const Duration _bookingCooldown = Duration(seconds: 100);
  static DateTime? _globalCooldownEndsAt;

  Timer? _cooldownEndTimer;

  bool isBooking = false;
  String? bookingError;

  bool get hasActivePass => passState.hasActivePass;
  bool get usesOneTimeFee => !hasActivePass;

  bool get isInCooldown {
    final endsAt = _globalCooldownEndsAt;
    if (endsAt == null) return false;
    return DateTime.now().isBefore(endsAt);
  }

  bool get canAttemptBooking =>
      bike.isAvailable && !isBooking && !isInCooldown;

  Future<Station?> bookBike() async {
    if (isBooking) return null;

    if (isInCooldown) {
      bookingError = 'Please wait a few seconds before booking another bike.';
      notifyListeners();
      return null;
    }

    isBooking = true;
    bookingError = null;
    notifyListeners();

    try {
      final updatedStation = await stationRepository.bookBike(
        stationId: station.id,
        bikeId: bike.id,
        dockId: dock.id,
      );
      _globalCooldownEndsAt = DateTime.now().add(_bookingCooldown);
      _scheduleCooldownEndNotification();
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

  void _scheduleCooldownEndNotification() {
    _cooldownEndTimer?.cancel();

    final endsAt = _globalCooldownEndsAt;
    if (endsAt == null) return;

    final remaining = endsAt.difference(DateTime.now());
    if (remaining.isNegative || remaining == Duration.zero) return;

    _cooldownEndTimer = Timer(remaining, () {
      notifyListeners();
    });
  }

  void _onPassChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _cooldownEndTimer?.cancel();
    passState.removeListener(_onPassChanged);
    super.dispose();
  }
}