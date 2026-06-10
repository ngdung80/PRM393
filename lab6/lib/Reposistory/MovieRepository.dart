import '../Entity/Movie.dart';

class MovieRepository {
  final List<Movie> _movies = const [
    Movie(
      title: 'Inception',
      year: 2010,
      genres: ['Action', 'Sci-Fi', 'Thriller'],
      posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500&auto=format&fit=crop',
      rating: 8.8,
    ),
    Movie(
      title: 'The Dark Knight',
      year: 2008,
      genres: ['Action', 'Crime', 'Drama'],
      posterUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?q=80&w=500&auto=format&fit=crop',
      rating: 9.0,
    ),
    Movie(
      title: 'Interstellar',
      year: 2014,
      genres: ['Adventure', 'Drama', 'Sci-Fi'],
      posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=500&auto=format&fit=crop',
      rating: 8.6,
    ),
    Movie(
      title: 'Spirited Away',
      year: 2001,
      genres: ['Animation', 'Adventure', 'Fantasy'],
      posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?q=80&w=500&auto=format&fit=crop',
      rating: 8.6,
    ),
    Movie(
      title: 'The Grand Budapest Hotel',
      year: 2014,
      genres: ['Comedy', 'Drama'],
      posterUrl: 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=500&auto=format&fit=crop',
      rating: 8.1,
    ),
    Movie(
      title: 'Pulp Fiction',
      year: 1994,
      genres: ['Crime', 'Drama'],
      posterUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?q=80&w=500&auto=format&fit=crop',
      rating: 8.9,
    ),
    Movie(
      title: 'Spider-Man: Into the Spider-Verse',
      year: 2018,
      genres: ['Animation', 'Action', 'Adventure', 'Sci-Fi'],
      posterUrl: 'https://images.unsplash.com/photo-1635805737707-575885ab0820?q=80&w=500&auto=format&fit=crop',
      rating: 8.4,
    ),
    Movie(
      title: 'Parasite',
      year: 2019,
      genres: ['Drama', 'Thriller', 'Mystery'],
      posterUrl: 'https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?q=80&w=500&auto=format&fit=crop',
      rating: 8.6,
    ),
  ];

  List<Movie> getAllMovies() {
    return _movies;
  }

  List<String> getAllGenres() {
    final Set<String> genres = {};
    for (var movie in _movies) {
      genres.addAll(movie.genres);
    }
    return genres.toList()..sort();
  }
}
