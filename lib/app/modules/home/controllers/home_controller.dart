import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/app/data/models/dto/configuration.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/models/dto/movie.dart';
import '../../../data/repository/tmdb_repository.dart';

class HomeController extends GetxController {
  final RxList<Movie> trendingMovies = <Movie>[].obs;
  final RxList<Movie> nowPlayingMovies = <Movie>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxDouble headerOpacity = 1.0.obs;

  final TMDBApiRepository _repository = TMDBApiRepository();
  late final ScrollController scrollController;
  Configuration? config;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_scrollListener);
    loadInitialData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    const double maxOffset = 200.0;
    final double offset = scrollController.offset;
    headerOpacity.value = (1.0 - (offset / maxOffset)).clamp(0.0, 1.0);
  }

  Future<void> loadInitialData() async {
    await _fetchAllMovies();
  }

  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      await _fetchAllMovies();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> _fetchAllMovies() async {
    try {
      isLoading.value = true;

      config = await _repository.getConfiguration();

      final results = await Future.wait([
        _repository.getTrendingMovie(),
        _repository.getNowPlayingMovie(),
      ]);

      final trendingResponse = results[0];
      final nowPlayingResponse = results[1];

      trendingMovies.assignAll(
        trendingResponse.map((e) => Movie.fromJson(e)).toList(),
      );

      debugPrint(trendingMovies.toString());
      nowPlayingMovies.assignAll(
        nowPlayingResponse.map((e) => Movie.fromJson(e)).toList(),
      );
    } catch (e) {
      debugPrint('Error loading movies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Widget get trendingShimmer => _buildShimmerSection();

  Widget get nowPlayingShimmer => _buildShimmerSection();

  Widget _buildShimmerSection() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 24,
            margin: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get heroBannerShimmer => Shimmer.fromColors(
    baseColor: Colors.grey[800]!,
    highlightColor: Colors.grey[600]!,
    child: Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
  );
}
