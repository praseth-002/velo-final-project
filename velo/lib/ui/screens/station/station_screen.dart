import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../data/repositories/station/station_repository.dart';
// import '../../../model/station/station.dart';
// import '../../../ui/screens/station/view_model/station_view_model.dart';
// import '../../../ui/screens/station/widgets/station_content.dart';
// import '../../../ui/states/pass_state.dart';

// class StationScreen extends StatelessWidget {
//   final Station station;

//   const StationScreen({super.key, required this.station});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => StationViewModel(
//         station: station,
//         stationRepository: context.read<StationRepository>(),
//         passState: context.read<PassState>(),
//       ),
//       child: const StationContent(),
//     );
//   }
// }

class StationScreen extends StatelessWidget {
  const StationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Station Details')),
      body: const Center(child: Text('Station details will be shown here.')),
    );
  }
}