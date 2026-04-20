import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo/model/station/station.dart';
import 'package:velo/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo/ui/screens/map/widgets/station_bottom_sheet.dart';
import 'package:velo/ui/screens/map/widgets/station_marker.dart';
import 'package:velo/ui/screens/station/station_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Future<void> _openStationDetails(BuildContext context, Station station) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StationScreen(station: station)),
    );
    await context.read<StationViewModel>().loadStations();
  }

  void _showStationSheet(BuildContext context, Station station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StationBottomSheet(
        station: station,
        onViewStation: () => _openStationDetails(context, station),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text("Station Map")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(11.5564, 104.9282),
          initialZoom: 14,
          maxZoom: 17,
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
                  onTap: () => _showStationSheet(context, station),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
