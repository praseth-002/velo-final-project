import 'package:flutter/material.dart';
import 'package:velo/model/station/station.dart';

class StationBottomSheet extends StatelessWidget {
  final Station station;
  final Future<void> Function() onViewStation;

  const StationBottomSheet({
    super.key,
    required this.station,
    required this.onViewStation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                station.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              _BikesBadge(count: station.bikesAvailableCount),
            ],
          ),
          const SizedBox(height: 4),

          // subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              // '${station.address} · ${station.distanceLabel}',
              station.address,
              style: const TextStyle(fontSize: 13, color: Colors.orange),
            ),
          ),
          const SizedBox(height: 16),

          // docks row
          _DocksRow(openDocks: station.openDocksCount),
          const SizedBox(height: 16),

          // button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await onViewStation();
              },
              child: const Text(
                'View Station',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _BikesBadge extends StatelessWidget {
  final int count;
  const _BikesBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const Text(
            'BIKES',
            style: TextStyle(fontSize: 10, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}

class _DocksRow extends StatelessWidget {
  final int openDocks;
  const _DocksRow({required this.openDocks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text('P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DOCKS', style: TextStyle(fontSize: 11, color: Colors.grey)),
              Text('$openDocks Open', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}