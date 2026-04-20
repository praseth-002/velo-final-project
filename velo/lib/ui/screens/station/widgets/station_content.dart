import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../ui/screens/station/view_model/station_view_model.dart';
import '../../../../ui/theme/theme.dart';

class StationContent extends StatelessWidget {
  const StationContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station info
            Text(vm.station.name, style: AppTextStyles.heading),
            const SizedBox(height: 8),
            Text(vm.station.address, style: AppTextStyles.body),
            const SizedBox(height: 12),
            Text(
              'Available: ${vm.station.availableBikes}/${vm.docks.length}',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 32),

            // Pass warning
            if (!vm.hasActivePass)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.orange.withOpacity(0.1),
                child: const Text('You need an active pass to book',
                    style: AppTextStyles.body),
              ),
            if (!vm.hasActivePass) const SizedBox(height: 16),

            // Docks
            Text('Docks', style: AppTextStyles.heading),
            const SizedBox(height: 12),
            ...vm.docks.map((dock) {
              final isSelected = vm.selectedDock?.id == dock.id;
              final available = dock.isAvailable;

              return GestureDetector(
                onTap: available ? () => vm.selectDock(dock) : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: available ? Colors.white : Colors.grey[100],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dock.label, style: AppTextStyles.body),
                          Text(
                            available ? 'Available' : 'Not Available',
                            style: TextStyle(
                              fontSize: 12,
                              color: available ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary),
                    ],
                  ),
                ),
              );
            }).toList(),
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
                    const Text('✓ Bike booked!'),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.canBook ? vm.bookBike : null,
                  child: const Text('Book Bike'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}