import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo/model/station/station.dart';
import 'package:velo/ui/screens/map/view_model/map_view_model.dart';
import 'package:velo/ui/screens/map/widgets/station_bottom_sheet.dart';
import 'package:velo/ui/screens/map/widgets/station_marker.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  void _showStationSheet(BuildContext context, Station station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StationBottomSheet(station: station),
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
                  availableBikes: station.availableBikes,
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
