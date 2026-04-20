import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/station/station_repository.dart';
import '../../../model/station/station.dart';
import '../../../ui/screens/station/view_model/station_view_model.dart';
import '../../../ui/screens/station/widgets/station_content.dart';
import '../../../ui/state/pass_state.dart';

class StationDetailsScreen extends StatelessWidget {
  final Station station;

  const StationDetailsScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StationDetailsViewModel(
        station: station,
        stationRepository: context.read<StationRepository>(),
        passState: context.read<PassState>(),
      ),
      child: const StationDetailsContent(),
    );
  }
}

class StationScreen extends StationDetailsScreen {
  const StationScreen({super.key, required super.station});
}