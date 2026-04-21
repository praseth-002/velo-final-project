import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo/model/station/station.dart';
import 'package:velo/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo/ui/screens/map/widgets/station_bottom_sheet.dart';
import 'package:velo/ui/screens/map/widgets/station_marker.dart';
import 'package:velo/ui/screens/map/widgets/station_search_bar.dart';
import 'package:velo/ui/screens/station/station_screen.dart';

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  final MapController _mapController = MapController();
  bool _mapReady = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _openStationDetails(Station station) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StationDetailsScreen(station: station)),
    );
    if (mounted) {
      await context.read<StationViewModel>().loadStations();
    }
  }

  void _showStationSheet(Station station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StationBottomSheet(
        station: station,
        onViewStation: () => _openStationDetails(station),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationViewModel>();

    if (_mapReady && vm.selectedStation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final station = vm.selectedStation!;
        context.read<StationViewModel>().clearSelectedStation();
        _mapController.move(LatLng(station.latitude, station.longitude), 16);

        // _showStationSheet(vm.selectedStation!);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(11.5564, 104.9282),
              initialZoom: 14,
              maxZoom: 17,
              onMapReady: () {
                setState(() => _mapReady = true);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              ),
              MarkerLayer(
                markers: vm.stations.map((station) {
                  return Marker(
                    point: LatLng(station.latitude, station.longitude),
                    width: 40,
                    height: 48,
                    child: StationMarker(
                      availableBikes: station.bikesAvailableCount,
                      onTap: () => _showStationSheet(station),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                StationSearchBar(
                  onSubmitted: (query) {
                    context.read<StationViewModel>().selectFirstResult();
                  },
                  onChanged: (value) {
                    context.read<StationViewModel>().searchStation(value);
                  },
                ),
                if (vm.searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: vm.searchResults.length,
                      itemBuilder: (context, index) {
                        final station = vm.searchResults[index];

                        return ListTile(
                          title: Text(station.name),
                          subtitle: Text(station.address),
                          onTap: () {
                            context.read<StationViewModel>().selectStation(
                              station,
                            );
                            context.read<StationViewModel>().searchStation(""); // clear results
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
            // child: StationSearchBar(
            //   onSubmitted: (query) {
            //     context.read<StationViewModel>().searchStation(query);
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}
