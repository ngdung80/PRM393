import 'package:flutter/material.dart';

class SortAndFilterBar extends StatelessWidget {
  final List<String> sortOptions;
  final String selectedSort;
  final ValueChanged<String?> onSortChanged;
  final bool isFiltered;
  final VoidCallback onClearFilters;

  const SortAndFilterBar({
    super.key,
    required this.sortOptions,
    required this.selectedSort,
    required this.onSortChanged,
    required this.isFiltered,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sort Dropdown
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort, size: 18, color: Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Slate 800
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSort,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w500),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8)),
                  onChanged: onSortChanged,
                  items: sortOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text('Sort: $option'),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        
        // Clear Filters Button
        if (isFiltered)
          TextButton.icon(
            onPressed: onClearFilters,
            icon: const Icon(Icons.filter_alt_off, size: 16, color: Color(0xFFF43F5E)), // Rose 500
            label: const Text(
              'Clear Filters',
              style: TextStyle(color: Color(0xFFF43F5E), fontSize: 13.0, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: const Color(0xFFF43F5E).withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
      ],
    );
  }
}
