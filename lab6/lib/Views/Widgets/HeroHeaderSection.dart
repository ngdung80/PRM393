import 'package:flutter/material.dart';

class HeroHeaderSection extends StatelessWidget {
  final int selectedGenresCount;

  const HeroHeaderSection({
    super.key,
    required this.selectedGenresCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF312E81), // Indigo 900
            Color(0xFF1E1B4B), // Custom deep violet
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Find a Movie',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              if (selectedGenresCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B), // Amber 500
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$selectedGenresCount',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore high-quality cinema. Filter by genre, search titles, and find your favorite movies.',
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xFFC7D2FE), // Indigo 200
            ),
          ),
        ],
      ),
    );
  }
}
