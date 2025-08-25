import 'package:get/get.dart';
import 'package:moviehub/app/modules/liked_movies/controllers/liked_movies_controller.dart';
import 'modules/bottom_nav/controllers/bottom_nav_controller.dart';
import 'modules/home/controllers/home_controller.dart';
import 'modules/search_movies/controllers/search_movies_controller.dart';

/// AppBinding class is responsible for initializing and managing dependencies using GetX's Bindings feature.
/// It ensures that ConfigRepository and UserRepository are available throughout the app lifecycle.

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LikedMoviesController(), permanent: true);
    Get.put(BottomNavController(), permanent: true);
    Get.put(SearchMoviesController(), permanent: true);
    Get.put(HomeController(), permanent: true);
  }
}
