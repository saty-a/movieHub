import 'package:get/get.dart';
import '../modules/bottom_nav/bindings/bottom_nav_binding.dart';
import '../modules/bottom_nav/views/bottom_nav_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/liked_movies/bindings/liked_movies_binding.dart';
import '../modules/liked_movies/views/liked_movies_view.dart';
import '../modules/movie_detail/bindings/movie_detail_binding.dart';
import '../modules/movie_detail/views/movie_detail_view.dart';
import '../modules/search_movies/bindings/search_movies_binding.dart';
import '../modules/search_movies/views/search_movies_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.BOTTAM_NAV;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MOVIE_DETAIL,
      page: () => const MovieDetailView(),
      binding: MovieDetailBinding(),
    ),
    GetPage(
      name: _Paths.LIKED_MOVIES,
      page: () => const LikedMoviesView(),
      binding: LikedMoviesBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_MOVIES,
      page: () => const SearchMoviesView(),
      binding: SearchMoviesBinding(),
    ),
    GetPage(
      name: _Paths.BOTTAM_NAV,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
    ),
  ];
}
