import 'package:flutter/material.dart';
import '../../Entity/Movie.dart';
import 'MovieCard.dart';

class MovieGridOrList extends StatelessWidget {
  final List<Movie> movies;

  const MovieGridOrList({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          // Phones and small screens: Single-column vertical list with fixed card height
          return ListView.builder(
            itemCount: movies.length,
            padding: const EdgeInsets.only(bottom: 24.0),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SizedBox(
                  height: 150,
                  child: MovieCard(movie: movies[index]),
                ),
              );
            },
          );
        } else {
          // Tablets and Web/Desktop: Two-column grid with a dynamically calculated aspect ratio
          // to ensure card height remains a constant 150 pixels regardless of width.
          final double itemWidth = (constraints.maxWidth - 16.0) / 2;
          final double dynamicAspectRatio = itemWidth / 150.0;

          return GridView.builder(
            itemCount: movies.length,
            padding: const EdgeInsets.only(bottom: 24.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: dynamicAspectRatio,
            ),
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        }
      },
    );
  }
}
