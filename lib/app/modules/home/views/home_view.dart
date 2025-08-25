import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/dto/movie.dart';
import '../../../widgets/movie_box.dart';
import '../controllers/home_controller.dart';
import 'movie_home_banner.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: Colors.amber,
          backgroundColor: const Color(0xFF161B22),
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              _buildMovieSections(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          backgroundColor: const Color(0xFF0D1117),
          flexibleSpace: FlexibleSpaceBar(
            background: controller.heroBannerShimmer,
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              controller.trendingShimmer,
              controller.nowPlayingShimmer,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      snap: false,
      backgroundColor: const Color(0xFF0D1117),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Obx(() => Opacity(
          opacity: 1.0 - controller.headerOpacity.value,
          child: const Text(
            'MovieHub',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )),
        background: _buildHeroBanner(),
      ),
    );
  }

  Widget _buildHeroBanner() {
    debugPrint(controller.trendingMovies.toString());
    return Obx(() {
      if (controller.trendingMovies.isEmpty) {
        return controller.heroBannerShimmer;
      }

      final featuredMovie = controller.trendingMovies.first;
      return HeroMovieBanner(
        movie: featuredMovie,
        config: controller.config!,
        opacity: controller.headerOpacity.value,
      );
    });
  }

  Widget _buildMovieSections() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildSectionTitle('🔥 Trending This Week'),
          _buildMovieList(controller.trendingMovies),
          const SizedBox(height: 30),
          _buildSectionTitle('🎬 Now Playing'),
          _buildMovieList(controller.nowPlayingMovies),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMovieList(RxList<Movie> movies) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 16),
      child: Obx(() {
        if (movies.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: MovieBox(
                key: ValueKey(movie.id),
                config: controller.config!,
                movie: movie,
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'No movies available',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
