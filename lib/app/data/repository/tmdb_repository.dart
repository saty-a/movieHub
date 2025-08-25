import 'package:moviehub/app/utils/constants.dart';

import '../models/dto/configuration.dart';
import '../models/dto/movie.dart';
import '../network/network_requester.dart';

class TMDBApiRepository {
  TMDBApiRepository();

  Future<List<Map<String, dynamic>>> getTrendingMovie({
    String type = 'all',
    String time = 'week',
  }) async {
    try {
      final response = await NetworkRequester.request.get(
        path: '/trending/$type/$time',
        query: {'api_key': Constants.apiKey},
      );
      return List<Map<String, dynamic>>.from(response['results']);
    } catch (e) {
      throw Exception('Failed to load trending: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNowPlayingMovie({
    String language = 'en-US',
    int page = 1,
  }) async {
    try {
      final response = await NetworkRequester.request.get(
        path: '/movie/now_playing',
        query: {
          'api_key': Constants.apiKey,
          'language': language,
          'page': page,
        },
      );

      return List<Map<String, dynamic>>.from(response['results']);
    } catch (e) {
      throw Exception('Failed to load trending: $e');
    }
  }

  Future<Configuration> getConfiguration() async {
    return Configuration.fromJson(
      await NetworkRequester.request.get(
        path: '/configuration',
        query: {'api_key': Constants.apiKey},
      ),
    );
  }

  Future<Movie> getDetails(int id, String type) async {
    try {
      return Movie.fromJson(
        await NetworkRequester.request.get(
          path: '/$type/$id',
          query: {'api_key': Constants.apiKey},
        ),
        medialType: type,
        details: true,
      );
    } catch (e) {
      throw Exception('Failed to load details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
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

      return List<Map<String, dynamic>>.from(response['results']);
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }
}
