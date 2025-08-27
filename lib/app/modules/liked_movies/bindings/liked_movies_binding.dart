import 'package:get/get.dart';

import '../controllers/liked_movies_controller.dart';

class LikedMoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikedMoviesController>(
      () => LikedMoviesController(),
    );
  }
}
