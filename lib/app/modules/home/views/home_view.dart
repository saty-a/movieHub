import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/highlight_movie.dart';
import '../../../widgets/movie_box.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          controller: controller.scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                const HighlightMovie(),
                _buildSectionTitle('Trending Movies This Week'),
                _buildMovieList(controller.trendingMovies),
              ]),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMovieList(RxList<dynamic> movies) {
    return SizedBox(
      height: 180.0,
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieBox(
            key: ValueKey(movie.id),
            movie: movie,
          );
        },
      )),
    );
  }
}
