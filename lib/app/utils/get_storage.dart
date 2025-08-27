import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/dto/movie.dart';

class StorageService extends GetxService {
  static StorageService get instance => Get.find<StorageService>();

  late GetStorage _box;
  static const String _favoritesKey = 'favorite_movies';

  // Initialize storage
  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  // Save favorite movies list
  Future<void> saveFavorites(List<Movie> favorites) async {
    try {
      final List favoritesJson = favorites
          .map((movie) => movie.toJson())
          .toList();
      await _box.write(_favoritesKey, favoritesJson);
      print('Favorites saved: ${favorites.length} movies');
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  // Get favorite movies list
  List<Movie> getFavorites() {
    try {
      final raw = _box.read(_favoritesKey);
      if (raw is List) {
        return raw
            .map((e) => e is Map<String, dynamic>
            ? Movie.fromJson(e)
            : null)
            .whereType<Movie>()
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }


  // Check if movie is favorite
  bool isFavorite(int movieId) {
    try {
      final favorites = getFavorites();
      return favorites.any((movie) => movie.id == movieId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Add movie to favorites
  Future<void> addToFavorites(Movie movie) async {
    try {
      final favorites = getFavorites();
      if (!favorites.any((m) => m.id == movie.id)) {
        favorites.add(movie);
        await saveFavorites(favorites);
      }
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  // Remove movie from favorites
  Future<void> removeFromFavorites(int movieId) async {
    try {
      final favorites = getFavorites();
      favorites.removeWhere((movie) => movie.id == movieId);
      await saveFavorites(favorites);
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      await _box.remove(_favoritesKey);
    } catch (e) {
      print('Error clearing favorites: $e');
    }
  }

  // Get favorites count
  int getFavoritesCount() {
    return getFavorites().length;
  }
}

