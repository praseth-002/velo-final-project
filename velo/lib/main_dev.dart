import 'package:provider/provider.dart';
import 'data/repositories/pass/pass_repository.dart';
import 'data/repositories/pass/pass_repository_mock.dart';
import 'data/repositories/station/station_repository.dart';
import 'data/repositories/station/station_repository_mock.dart';
import 'main_common.dart';
import 'ui/states/pass_state.dart';

List<InheritedProvider> get devProviders {
  final passRepo = PassRepositoryMock();
  final stationRepo = StationRepositoryMock();
  return [
    Provider<PassRepository>(create: (_) => passRepo),
    Provider<StationRepository>(create: (_) => stationRepo),
    ChangeNotifierProvider<PassState>(
      create: (_) => PassState(repository: passRepo),
    ),
  ];
}

void main() {
  mainCommon(devProviders);
}
