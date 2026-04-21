import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo/ui/screens/map/widgets/map_content.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationViewModel(
        context.read<StationRepository>(),
      )..loadStations(),
      child: const MapContent(),
    );
  }
}