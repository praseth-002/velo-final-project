import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo/model/station/station.dart';
import 'package:velo/ui/screens/bike/bike_details_screen.dart';
import '../../../../ui/screens/station/view_model/station_view_model.dart';
import '../../../../ui/theme/theme.dart';

class StationDetailsContent extends StatelessWidget {
  const StationDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationDetailsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vm.station.name, style: AppTextStyles.heading),
                  const SizedBox(height: 6),
                  Text(vm.station.address, style: AppTextStyles.body),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Available Bikes',
                    value: vm.station.bikesAvailableCount.toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Open Docks',
                    value: vm.station.openDocksCount.toString(),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Docks
            Text('Pick a Bike', style: AppTextStyles.heading),
            const SizedBox(height: 6),
            const Text(
              'Tap any available bike to view details and book.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            if (vm.docksWithAvailableBikes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Text(
                  'No available bikes at this station right now.',
                  style: AppTextStyles.body,
                ),
              ),
            ...vm.docksWithAvailableBikes.map((dock) {
              final bike = vm.availableBikeForDock(dock);
              if (bike == null) return const SizedBox.shrink();

              return GestureDetector(
                onTap: () async {
                  final updatedStation = await Navigator.push<Station>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BikeDetailsScreen(
                        station: vm.station,
                        dock: dock,
                        bike: bike,
                      ),
                    ),
                  );

                  if (!context.mounted || updatedStation == null) return;

                  vm.updateStation(updatedStation);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.cardBorder,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dock.label,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Bike ID: ${bike.id}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class StationContent extends StatelessWidget {
  const StationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const StationDetailsContent();
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
