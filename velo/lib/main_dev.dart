import 'package:provider/provider.dart';
import 'package:velo/data/repositories/station/station_repository.dart';
import 'package:velo/data/repositories/station/station_repository_mock.dart';
import 'package:velo/ui/screens/map/view_model/map_view_model.dart';
import 'data/repositories/pass/pass_repository.dart';
import 'data/repositories/pass/pass_repository_mock.dart';
// import 'data/repositories/station/station_repository.dart';
// import 'data/repositories/station/station_repository_mock.dart';
import 'main_common.dart';
import 'ui/state/pass_state.dart';

List<InheritedProvider> get devProviders {
  final passRepo = MockPassRepository();
  final stationRepo = StationRepositoryMock();
  return [
    Provider<PassRepository>(create: (_) => passRepo),
    // Provider<StationRepository>(create: (_) => stationRepo),
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
