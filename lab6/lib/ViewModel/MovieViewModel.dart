import 'package:flutter/material.dart';
import '../Entity/Movie.dart';
import '../Reposistory/MovieRepository.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  String _searchQuery = '';
  final Set<String> _selectedGenres = {};
  String _selectedSort = 'A-Z';

  String get searchQuery => _searchQuery;
  Set<String> get selectedGenres => _selectedGenres;
  String get selectedSort => _selectedSort;

  List<String> get availableGenres => _repository.getAllGenres();

  bool get isFiltered => _searchQuery.isNotEmpty || _selectedGenres.isNotEmpty || _selectedSort != 'A-Z';

  // Getter to filter and sort movies dynamically
  List<Movie> get visibleMovies {
    // 1. Get all movies from repository
    final List<Movie> movies = _repository.getAllMovies();

    // 2. Filter movies
    final List<Movie> filtered = movies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenres.isEmpty || 
          movie.genres.any((genre) => _selectedGenres.contains(genre));
      return matchesSearch && matchesGenre;
    }).toList();

    // 3. Sort movies
    switch (_selectedSort) {
      case 'A-Z':
        filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case 'Year':
        filtered.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  // Update actions
  void updateSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void toggleGenre(String genre) {
    if (_selectedGenres.contains(genre)) {
      _selectedGenres.remove(genre);
    } else {
      _selectedGenres.add(genre);
    }
    notifyListeners();
  }

  void updateSort(String sort) {
    if (_selectedSort != sort) {
      _selectedSort = sort;
      notifyListeners();
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedGenres.clear();
    _selectedSort = 'A-Z';
    notifyListeners();
  }
}
