import 'package:flutter/material.dart';
import '../ViewModel/MovieViewModel.dart';
import 'Widgets/HeroHeaderSection.dart';
import 'Widgets/MovieSearchBar.dart';
import 'Widgets/GenreChipsSection.dart';
import 'Widgets/SortAndFilterBar.dart';
import 'Widgets/NoMoviesFallback.dart';
import 'Widgets/MovieGridOrList.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final MovieViewModel _viewModel = MovieViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (_searchController.text != _viewModel.searchQuery) {
      _searchController.text = _viewModel.searchQuery;
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        final visibleMovies = _viewModel.visibleMovies;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero & Heading Section
                  HeroHeaderSection(selectedGenresCount: _viewModel.selectedGenres.length),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  MovieSearchBar(
                    controller: _searchController,
                    onChanged: (value) => _viewModel.updateSearchQuery(value),
                    onClear: () => _viewModel.updateSearchQuery(''),
                  ),
                  const SizedBox(height: 16),
                  
                  // Genre Label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter by Genre',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF8FAFC),
                        ),
                      ),
                      if (_viewModel.selectedGenres.isNotEmpty)
                        Text(
                          '${_viewModel.selectedGenres.length} selected',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Wrap Genre Chips
                  GenreChipsSection(
                    availableGenres: _viewModel.availableGenres,
                    selectedGenres: _viewModel.selectedGenres,
                    onGenreToggled: (genre) => _viewModel.toggleGenre(genre),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sort Bar & Clear Filter button
                  SortAndFilterBar(
                    sortOptions: const ['A-Z', 'Z-A', 'Year', 'Rating'],
                    selectedSort: _viewModel.selectedSort,
                    onSortChanged: (newSort) {
                      if (newSort != null) {
                        _viewModel.updateSort(newSort);
                      }
                    },
                    isFiltered: _viewModel.isFiltered,
                    onClearFilters: () => _viewModel.clearFilters(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Responsive Movie List / Grid Section
                  Expanded(
                    child: visibleMovies.isEmpty
                        ? const NoMoviesFallback()
                        : MovieGridOrList(movies: visibleMovies),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
