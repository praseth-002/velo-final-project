import 'package:flutter/material.dart';

class StationMarker extends StatelessWidget {
  final int availableBikes;
  final VoidCallback onTap;
  const StationMarker({
    super.key,
    required this.availableBikes,
    required this.onTap,
  });

  Color get _markerColor {
    if (availableBikes > 0) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 48,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _markerColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(4), // the pointy corner
                    bottomRight: Radius.circular(18),
                  ),
                ),
              ),
            ),
            // text sits on top, unrotated
            Positioned(
              top: 4,
              child: Text(
                '$availableBikes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
