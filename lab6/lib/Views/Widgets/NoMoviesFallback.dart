import 'package:flutter/material.dart';

class NoMoviesFallback extends StatelessWidget {
  const NoMoviesFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.movie_creation_outlined,
          size: 64,
          color: Color(0xFF475569), // Slate 600
        ),
        SizedBox(height: 16),
        Text(
          'No Movies Found',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Try adjusting your search query or removing genre filters.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
