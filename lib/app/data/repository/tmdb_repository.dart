import '../models/response/trending_movie.dart';
import '../network/retrofit_service.dart';

class TMDBRepository {
  TMDBRepository({required this.restClient});

  final MovieApiService restClient;

  Future<List<Movie>> getTrending({
    type = 'all',
    time = 'week',
    page = 1,
  }) async {
    final response = await restClient.getTrendingMovies(page);
    return response.results;
  }

  // Future<Configuration> getConfiguration() async {
  //   return Configuration.fromJson(await _client.getConfiguration());
  // }
  //
  // Future<Movie> getDetails(id, type) async {
  //   return Movie.fromJson(await _client.getDetails(id, type),
  //       medialType: type, details: true);
  // }
  //
  // Future<Season> getSeason(id, season) async {
  //   return Season.fromJson(await _client.getSeason(id, season));
  // }
  //
  // Future<List<Movie>> discover(type) async {
  //   return (await _client.discover(type))
  //       .map((item) => Movie.fromJson(item, medialType: type))
  //       .toList();
  // }
  //
  // Future<TMDBImages> getImages(id, type) async {
  //   return TMDBImages.fromJson(await _client.getImages(id, type));
  // }
}
