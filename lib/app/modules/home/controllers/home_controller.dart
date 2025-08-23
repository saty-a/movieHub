import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/response/trending_movie.dart';
import '../../../data/network/retrofit_service.dart';
import '../../../data/repository/tmdb_repository.dart';

class HomeController extends GetxController {
  final RxList<Movie> trendingMovies = <Movie>[].obs;
  final RxBool isLoading = true.obs;
  
  late final TMDBRepository _repository;
  late final ScrollController scrollController;
  
  @override
  void onInit() {
    super.onInit();
    _repository = TMDBRepository(restClient: MovieApiService(Get.find()));
    scrollController = ScrollController()
      ..addListener(() {
        scrollOffset = scrollController.offset;
      });
    
    // Load initial data
    loadTrendingMovies();
  }
  
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  
  double scrollOffset = 0.0;
  
  Future<void> loadTrendingMovies() async {
    try {
      isLoading.value = true;
      final movies = await _repository.getTrending();
      trendingMovies.assignAll(movies);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load trending movies',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error loading trending movies: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Shimmer effect for loading state
  Widget get shimmer => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}
