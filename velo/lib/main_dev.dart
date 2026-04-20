import 'package:provider/provider.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/data/repositories/station/station_repository_mock.dart';
import 'package:velo/data/repositories/station/station_repository_firebase.dart';
import 'package:velo/ui/screens/map/view_model/map_view_model.dart';
import 'data/repositories/pass/pass_repository.dart';
import 'data/repositories/pass/pass_repository_mock.dart';
import 'data/repositories/pass/pass_repository_firebase.dart';
import 'main_common.dart';
import 'ui/state/pass_state.dart';

// Toggle between mock and Firebase repos
const bool USE_FIREBASE_STATIONS = true;
const bool USE_FIREBASE_PASSES = true;

List<InheritedProvider> get devProviders {
  // Use Firebase or mock based on flags
  final PassRepository passRepo = USE_FIREBASE_PASSES
      ? PassRepositoryFirebase()
      : MockPassRepository();
  
  final StationRepository stationRepo = USE_FIREBASE_STATIONS
      ? StationRepositoryFirebase()
      : StationRepositoryMock();
  
  return [
    Provider<PassRepository>(create: (_) => passRepo),
    ChangeNotifierProvider<PassState>(
      create: (_) => PassState(repository: passRepo),
    ),
    Provider<StationRepository>(create: (_) => stationRepo),
    ChangeNotifierProvider<StationViewModel>(
      create: (_) => StationViewModel(stationRepo)..loadStations(),
    ),
  ];
}

void main() {
  mainCommon(devProviders);
}
