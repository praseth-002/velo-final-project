import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo/ui/screens/pass/pass_screen.dart';
import '../../../../ui/screens/station/view_model/station_view_model.dart';
import '../../../../ui/theme/theme.dart';

class StationContent extends StatelessWidget {
  const StationContent({super.key});

  String _bookButtonLabel(StationDetailsViewModel vm) {
    if (vm.bookingStatus == BookingStatus.loading) return 'Booking...';
    return vm.usesOneTimeFee ? 'Book with One-Time Fee' : 'Book Bike';
  }

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
            // Station info
            Text(vm.station.name, style: AppTextStyles.heading),
            const SizedBox(height: 8),
            Text(vm.station.address, style: AppTextStyles.body),
            const SizedBox(height: 12),
            Text(
              'Available Bikes: ${vm.station.bikesAvailableCount}',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            Text(
              'Available Parking: ${vm.station.openDocksCount}',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 32),

            // Pass warning
            if (!vm.hasActivePass)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.orange.withOpacity(0.1),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'No active pass. You can still book with a one-time fee, or get a pass.',
                        style: AppTextStyles.body,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PassScreen()),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Go to pass screen',
                    ),
                  ],
                ),
              ),
            if (!vm.hasActivePass) const SizedBox(height: 16),

            // Docks
            Text('Docks With Bikes', style: AppTextStyles.heading),
            const SizedBox(height: 12),
            ...vm.docksWithAvailableBikes.map((dock) {
              final isSelected = vm.selectedDock?.id == dock.id;
              final bike = vm.availableBikeForDock(dock);

              return GestureDetector(
                onTap: () => vm.selectDock(dock),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dock.label, style: AppTextStyles.body),
                          if (bike != null)
                            Text(
                              'Bike ID: ${bike.id}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),

            // Status messages
            if (vm.bookingStatus == BookingStatus.loading)
              const Center(child: CircularProgressIndicator())
            else if (vm.bookingStatus == BookingStatus.success)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.green.withOpacity(0.1),
                child: Column(
                  children: [
                    Text(
                      vm.usesOneTimeFee
                          ? '✓ Bike booked with one-time fee!'
                          : '✓ Bike booked!',
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.resetBookingStatus,
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              )
            else if (vm.bookingStatus == BookingStatus.error)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.red.withOpacity(0.1),
                child: Column(
                  children: [
                    Text(vm.bookingError ?? 'Booking failed'),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.resetBookingStatus,
                        child: const Text('Try Again'),
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: vm.selectedDock == null
          ? null
          : SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: ElevatedButton(
                onPressed: vm.canBook ? vm.bookBike : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(_bookButtonLabel(vm)),
              ),
            ),
    );
  }
}
