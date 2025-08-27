import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/dto/configuration.dart';
import '../../../data/models/dto/movie.dart';
import '../../../data/repository/tmdb_repository.dart';
import '../../../utils/get_storage.dart';

class LikedMoviesController extends GetxController {
  final StorageService _storageService = StorageService.instance;

  // Observables
  final _favoriteMovies = <Movie>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  Configuration? config;
  final TMDBApiRepository _repository = TMDBApiRepository();

  // Getters
  List<Movie> get favoriteMovies => _favoriteMovies.value;

  bool get isLoading => _isLoading.value;

  String get searchQuery => _searchQuery.value;

  int get favoritesCount => _favoriteMovies.length;

  // Filtered favorites based on search
  List<Movie> get filteredFavorites {
    if (_searchQuery.value.isEmpty) {
      return _favoriteMovies;
    }
    return _favoriteMovies
        .where(
          (movie) => movie.name.toLowerCase().contains(
            _searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadFavorites();

    ever(_favoriteMovies, (_) {
      _saveFavoritesToStorage();
    });
  }

  void loadFavorites() async {
    try {
      _isLoading.value = true;
      config = await _repository.getConfiguration();
      final favorites = _storageService.getFavorites();
      _favoriteMovies.assignAll(favorites);
      debugPrint('Loaded ${favorites.length} favorite movies');
    } catch (e) {
      _showErrorSnackbar('Failed to load favorites');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addToFavorites(Movie movie) async {
    try {
      if (!isFavorite(movie.id)) {
        _favoriteMovies.add(movie);
        await _storageService.addToFavorites(movie);

        Get.snackbar(
          'Added to Favorites',
          '${movie.name} has been added to your favorites',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.favorite, color: Colors.white),
          margin: EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      _showErrorSnackbar('Failed to add to favorites');
    }
  }

  // Remove movie from favorites
  Future<void> removeFromFavorites(int movieId) async {
    try {
      final movieToRemove = _favoriteMovies.firstWhere(
        (movie) => movie.id == movieId,
        orElse: () => throw Exception('Movie not found'),
      );

      _favoriteMovies.removeWhere((movie) => movie.id == movieId);
      await _storageService.removeFromFavorites(movieId);

      Get.snackbar(
        'Removed from Favorites',
        '${movieToRemove.name} has been removed from your favorites',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.favorite_border, color: Colors.white),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      _showErrorSnackbar('Failed to remove from favorites');
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      await removeFromFavorites(movie.id);
    } else {
      await addToFavorites(movie);
    }
  }

  // Check if movie is favorite
  bool isFavorite(int movieId) {
    debugPrint("Movie Id $movieId");
    return _favoriteMovies.any((movie) => movie.id == movieId);
  }

  // Search favorites
  void searchFavorites(String query) {
    _searchQuery.value = query;
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      // Show confirmation dialog
      final bool? confirm = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Clear All Favorites'),
          content: Text(
            'Are you sure you want to remove all favorites? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Clear All'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        _favoriteMovies.clear();
        await _storageService.clearAllFavorites();

        Get.snackbar(
          'Favorites Cleared',
          'All favorites have been removed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.clear_all, color: Colors.white),
          margin: EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      _showErrorSnackbar('Failed to clear favorites');
    }
  }

  // Refresh favorites
  Future<void> refreshFavorites() async {
    loadFavorites();
  }

  // Sort favorites
  void sortFavorites(String sortBy) {
    switch (sortBy) {
      case 'name':
        _favoriteMovies.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'date_added':
        // Sort by date added (most recent first)
        // You might want to add a dateAdded field to track this
        break;
      case 'rating':
        _favoriteMovies.sort(
          (a, b) => (b.voteAverage ?? 0).compareTo(a.voteAverage ?? 0),
        );
        break;
      case 'year':
        _favoriteMovies.sort(
          (a, b) =>
              (b.releaseDate?.year ?? 0).compareTo(a.releaseDate?.year ?? 0),
        );
        break;
    }
  }

  // Private methods
  Future<void> _saveFavoritesToStorage() async {
    await _storageService.saveFavorites(_favoriteMovies);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
