import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/model/bike/bike.dart';
import 'package:velo/model/dock/dock.dart';
import 'package:velo/model/station/station.dart';
import 'package:velo/ui/screens/bike/view_model/bike_details_view_model.dart';
import 'package:velo/ui/state/pass_state.dart';
import 'package:velo/ui/screens/bike/widgets/bike_details_content.dart';

class BikeDetailsScreen extends StatelessWidget {
  final Station station;
  final Dock dock;
  final Bike bike;

  const BikeDetailsScreen({
    super.key,
    required this.station,
    required this.dock,
    required this.bike,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BikeDetailsViewModel(
        station: station,
        dock: dock,
        bike: bike,
        stationRepository: context.read<StationRepository>(),
        passState: context.read<PassState>(),
      ),
      child: const BikeDetailsContent(),
    );
  }
}
