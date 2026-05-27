import 'package:flutter/material.dart';

/// Exercise 3 – Layout Basics: Column, Row, Padding, ListView
/// Goal: Build a sectioned UI layout similar to a real app Home screen.
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  // Dữ liệu mẫu danh sách phim
  static const List<Map<String, String>> _movies = [
    {'title': 'Avatar', 'description': 'Sample description'},
    {'title': 'Inception', 'description': 'Sample description'},
    {'title': 'Interstellar', 'description': 'Sample description'},
    {'title': 'Joker', 'description': 'Sample description'},
    {'title': 'The Dark Knight', 'description': 'Sample description'},
    {'title': 'Avengers', 'description': 'Sample description'},
    {'title': 'Spider-Man', 'description': 'Sample description'},
    {'title': 'Dune', 'description': 'Sample description'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 – Layout Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Now Playing',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Movies', '${_movies.length}'),
                _buildStat('Genre', 'All'),
                _buildStat('Rating', '★ 8.0+'),
              ],
            ),
          ),

          const SizedBox(height: 12), 

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        child: Text(
                          movie['title']![0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        movie['title']!,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(movie['description']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
