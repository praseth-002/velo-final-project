import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo/ui/screens/pass/pass_screen.dart';
import 'package:velo/ui/screens/bike/view_model/bike_details_view_model.dart';
import 'package:velo/ui/theme/theme.dart';

class BikeDetailsContent extends StatelessWidget {
  const BikeDetailsContent({super.key});

  Future<void> _bookBike(BuildContext context) async {
    final vm = context.read<BikeDetailsViewModel>();
    final updatedStation = await vm.bookBike();

    if (!context.mounted) return;

    if (updatedStation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.bookingError ?? 'Booking failed.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          vm.usesOneTimeFee
              ? 'Bike booked with one-time fee.'
              : 'Bike booked successfully.',
        ),
      ),
    );

    Navigator.pop(context, updatedStation);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BikeDetailsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bike Details'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ride Info', style: AppTextStyles.heading),
                      const SizedBox(height: 12),
                      Text('Bike ID: ${vm.bike.id}', style: AppTextStyles.body),
                      const SizedBox(height: 6),
                      Text('Dock: ${vm.dock.label}', style: AppTextStyles.body),
                      const SizedBox(height: 6),
                      Text(
                        'Status: ${vm.bike.isAvailable ? 'Available' : 'Checked Out'}',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  tint: vm.usesOneTimeFee ? AppColors.primaryLight : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Pricing', style: AppTextStyles.heading),
                      // const SizedBox(height: 8),
                      Text(
                        vm.usesOneTimeFee
                            ? 'No active pass. This booking uses one-time fee.'
                            : 'Active pass detected. No one-time fee needed.',
                        style: AppTextStyles.body,
                      ),
                      if (vm.usesOneTimeFee) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PassScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('View Pass Options'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: vm.isBooking ? null : () => _bookBike(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColors.primary
                ),
                child: Text(
                  style: TextStyle(color: AppColors.cardBackground),
                  vm.isBooking
                      ? 'Booking...'
                      : vm.usesOneTimeFee
                          ? 'Book with One-Time Fee'
                          : 'Book Bike',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.tint = Colors.white});

  final Widget child;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}