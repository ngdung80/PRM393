import 'package:flutter/material.dart';

class GenreChipsSection extends StatelessWidget {
  final List<String> availableGenres;
  final Set<String> selectedGenres;
  final ValueChanged<String> onGenreToggled;

  const GenreChipsSection({
    super.key,
    required this.availableGenres,
    required this.selectedGenres,
    required this.onGenreToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableGenres.map((genre) {
        final isSelected = selectedGenres.contains(genre);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onGenreToggled(genre),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo to Violet
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : const Color(0xFF1E293B), // Slate 800
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF818CF8) // Indigo 400
                        : const Color(0xFF334155), // Slate 700
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  genre,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFE2E8F0), // Slate 200
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
