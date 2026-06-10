import 'package:flutter/material.dart';
import '../../Entity/Movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: _isHovered
            ? Matrix4.translationValues(0.0, -4.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), // Slate 800
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF6366F1).withOpacity(0.8) // Highlight color
                : const Color(0xFF334155), // Slate 700
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF6366F1).withOpacity(0.25)
                  : Colors.black.withOpacity(0.2),
              blurRadius: _isHovered ? 12 : 6,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, cardConstraints) {
            // Adjust layouts dynamically based on card size
            final cardWidth = cardConstraints.maxWidth;
            // Decide poster width proportionally
            final double posterWidth = cardWidth < 300 
                ? cardWidth * 0.3 
                : (cardWidth < 500 ? 110.0 : 130.0);

            return Row(
              children: [
                // Movie Poster Section
                SizedBox(
                  width: posterWidth,
                  height: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.movie.posterUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFF0F172A),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF0F172A),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, color: Color(0xFF475569), size: 32),
                                SizedBox(height: 4),
                                Text(
                                  'No Poster',
                                  style: TextStyle(color: Color(0xFF475569), fontSize: 10),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Top gradient overlay on image
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Movie Details Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Rating row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Numeric Rating with Star Icon in custom capsule
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFFF59E0B).withOpacity(0.5),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.movie.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Color(0xFFF59E0B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        // Release Year
                        Text(
                          widget.movie.year.toString(),
                          style: const TextStyle(
                            color: Color(0xFF94A3B8), // Slate 400
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Mini Genre Tags in card
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: widget.movie.genres.take(3).map((g) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF334155), // Slate 700
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                g,
                                style: const TextStyle(
                                  color: Color(0xFFCBD5E1), // Slate 300
                                  fontSize: 10.0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
