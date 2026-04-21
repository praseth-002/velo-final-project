import 'package:flutter/material.dart';

class StationSearchBar extends StatelessWidget {
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const StationSearchBar({super.key, required this.onSubmitted, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.grey, size: 20),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.black),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search Station...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
