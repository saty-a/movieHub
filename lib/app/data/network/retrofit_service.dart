import 'package:moviehub/app/data/models/response/trending_movie.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'retrofit_service.g.dart';

@RestApi()
abstract class MovieApiService {
  factory MovieApiService(Dio dio) = _MovieApiService;

  @GET('/trending/movie/week')
  Future<TrendingMovieResponse> getTrendingMovies(
      @Query('page') int page,
      );

  @GET('/movie/now_playing')
  Future<TrendingMovieResponse> getNowPlayingMovies(
      @Query('page') int page,
      );

  @GET('/movie/{id}')
  Future<TrendingMovieResponse> getMovieDetail(
      @Path('id') int id,
      );

  @GET('/search/movie')
  Future<TrendingMovieResponse> searchMovies(
      @Query('query') String query,
      @Query('page') int page,
      );

  @GET('/genre/movie/list')
  Future<TrendingMovieResponse> getGenres();
}