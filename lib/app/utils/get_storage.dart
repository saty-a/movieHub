import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/dto/movie.dart';

class StorageService extends GetxService {
  static StorageService get instance => Get.find<StorageService>();

  late GetStorage _box;
  static const String _favoritesKey = 'favorite_movies';
  static const String _apiCachePrefix = 'api_cache:';
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

  // Generic API response caching
  String _cacheKey(String key) => '$_apiCachePrefix$key';

  Future<void> cacheWrite(String key, dynamic data) async {
    try {
      final payload = {
        'data': data,
        'ts': DateTime.now().toIso8601String(),
      };
      await _box.write(_cacheKey(key), payload);
    } catch (e) {
      print('Error writing cache for $key: $e');
    }
  }

  /// Read cached response or  returns null if missing or malformed
  T? cacheRead<T>(String key) {
    try {
      final raw = _box.read(_cacheKey(key));
      if (raw is Map && raw['data'] != null) {
        return raw['data'] as T;
      }
      return null;
    } catch (e) {
      print('Error reading cache for $key: $e');
      return null;
    }
  }

  /// Get the timestamp when this cache entry was written
  DateTime? cacheTimestamp(String key) {
    try {
      final raw = _box.read(_cacheKey(key));
      if (raw is Map && raw['ts'] is String) {
        return DateTime.tryParse(raw['ts'] as String);
      }
      return null;
    } catch (e) {
      print('Error reading cache timestamp for $key: $e');
      return null;
    }
  }

  /// Check if a cached entry exists and is not older than [maxAge]
  bool cacheIsFresh(String key, Duration maxAge) {
    final ts = cacheTimestamp(key);
    if (ts == null) return false;
    return DateTime.now().difference(ts) <= maxAge;
  }

  /// Remove a cached entry
  Future<void> cacheRemove(String key) async {
    try {
      await _box.remove(_cacheKey(key));
    } catch (e) {
      print('Error removing cache for $key: $e');
    }
  }
}
