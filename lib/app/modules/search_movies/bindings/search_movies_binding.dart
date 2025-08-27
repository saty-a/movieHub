import 'package:get/get.dart';

import '../controllers/search_movies_controller.dart';

class SearchMoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchMoviesController>(
      () => SearchMoviesController(),
    );
  }
}
