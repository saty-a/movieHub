import 'package:moviehub/app/utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:moviehub/app/utils/get_storage.dart';

import '../models/dto/configuration.dart';
import '../models/dto/movie.dart';
import '../network/network_requester.dart';

class TMDBApiRepository {
  TMDBApiRepository();

  final _storage = StorageService.instance;
  final _connectivity = Connectivity();

  Future<bool> _isOffline() async {
    final res = await _connectivity.checkConnectivity();
    return res.contains(ConnectivityResult.none);
  }

  Future<List<Map<String, dynamic>>> getTrendingMovie({
    String type = 'all',
    String time = 'week',
  }) async {
    final cacheKey = 'trending:$type:$time';
    final offline = await _isOffline();
    if (offline) {
      final cached = _storage.cacheRead<List<dynamic>>(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
    }
    try {
      final response = await NetworkRequester.request.get(
        path: '/trending/$type/$time',
        query: {'api_key': Constants.apiKey},
      );
      final results = List<Map<String, dynamic>>.from(response['results']);
      await _storage.cacheWrite(cacheKey, results);
      return results;
    } catch (e) {
      final cached = _storage.cacheRead<List<dynamic>>(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      throw Exception('Failed to load trending: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNowPlayingMovie({
    String language = 'en-US',
    int page = 1,
  }) async {
    final cacheKey = 'now_playing:$language:$page';
    final offline = await _isOffline();
    if (offline) {
      final cached = _storage.cacheRead<List<dynamic>>(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
    }
    try {
      final response = await NetworkRequester.request.get(
        path: '/movie/now_playing',
        query: {
          'api_key': Constants.apiKey,
          'language': language,
          'page': page,
        },
      );
      final results = List<Map<String, dynamic>>.from(response['results']);
      // cache for 6 hours
      await _storage.cacheWrite(cacheKey, results);
      return results;
    } catch (e) {
      final cached = _storage.cacheRead<List<dynamic>>(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      throw Exception('Failed to load now playing: $e');
    }
  }

  Future<Configuration> getConfiguration() async {
    const cacheKey = 'configuration';
    final offline = await _isOffline();
    if (offline) {
      final cached = _storage.cacheRead<Map<String, dynamic>>(cacheKey);
      if (cached != null) return Configuration.fromJson(cached);
    }
    try {
      final json = await NetworkRequester.request.get(
        path: '/configuration',
        query: {'api_key': Constants.apiKey},
      );
      await _storage.cacheWrite(cacheKey, json);
      return Configuration.fromJson(json);
    } catch (e) {
      final cached = _storage.cacheRead<Map<String, dynamic>>(cacheKey);
      if (cached != null) return Configuration.fromJson(cached);
      throw Exception('Failed to load configuration: $e');
    }
  }

  Future<Movie> getDetails(int id, String type) async {
    final cacheKey = 'details:$type:$id';
    final offline = await _isOffline();
    if (offline) {
      final cached = _storage.cacheRead<Map<String, dynamic>>(cacheKey);
      if (cached != null) {
        return Movie.fromJson(cached, medialType: type, details: true);
      }
    }
    try {
      final json = await NetworkRequester.request.get(
        path: '/$type/$id',
        query: {'api_key': Constants.apiKey},
      );
      await _storage.cacheWrite(cacheKey, json);
      return Movie.fromJson(json, medialType: type, details: true);
    } catch (e) {
      final cached = _storage.cacheRead<Map<String, dynamic>>(cacheKey);
      if (cached != null) {
        return Movie.fromJson(cached, medialType: type, details: true);
      }
      throw Exception('Failed to load details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final cacheKey = 'search:$query';
    final offline = await _isOffline();
    if (offline) {
      final cached = _storage.cacheRead<List<dynamic>>(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      return [];
    }
    try {
      final response = await NetworkRequester.request.get(
        path: '/search/movie',
        query: {
          'api_key': Constants.apiKey,
          'language': 'en-US',
          'query': query,
          'page': '1',
          'include_adult': 'false',
        },
      );
      final results = response['results'] as List<dynamic>?;
      if (results == null) {
        return [];
      }
      final mapped = List<Map<String, dynamic>>.from(results);
      await _storage.cacheWrite(cacheKey, mapped);
      return mapped;
    } catch (e) {
      final cached = _storage.cacheRead<List<dynamic>>(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      throw Exception('Failed to search movies: $e');
    }
  }
}
