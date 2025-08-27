import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:moviehub/app/modules/liked_movies/controllers/liked_movies_controller.dart';
import 'package:moviehub/app/widgets/movie_box.dart';
import '../../../data/models/dto/movie.dart';

class LikedMoviesView extends GetView<LikedMoviesController> {
  const LikedMoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: SafeArea(child: Obx(() => _buildBody())),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 2,
      shadowColor: Colors.red.withOpacity(0.5),
      title: const Text(
        'My Favorites',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.search, color: Colors.white),
          onPressed: _showSearchDialog,
          tooltip: 'Search favorites',
        ),
        PopupMenuButton<String>(
          icon: const Icon(LucideIcons.filter, color: Colors.white),
          color: Colors.grey[900],
          onSelected: (value) => controller.sortFavorites(value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'name',
              child: Row(
                children: const [
                  Icon(Icons.sort_by_alpha, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text('Sort by Name', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'rating',
              child: Row(
                children: const [
                  Icon(Icons.star, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text('Sort by Rating', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'year',
              child: Row(
                children: const [
                  Icon(Icons.calendar_today, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text('Sort by Year', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(LucideIcons.moreVertical, color: Colors.white),
          color: Colors.grey[900],
          onSelected: (value) {
            if (value == 'clear_all') {
              controller.clearAllFavorites();
            } else if (value == 'refresh') {
              controller.refreshFavorites();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: const [
                  Icon(Icons.refresh, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text('Refresh', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: const [
                  Icon(Icons.clear_all, color: Colors.red, size: 20),
                  SizedBox(width: 12),
                  Text('Clear All', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (controller.isLoading) {
      return _buildLoadingState();
    }

    if (controller.filteredFavorites.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildSearchBar(),
        _buildFavoritesHeader(),
        Expanded(child: _buildFavoritesList()),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.redAccent),
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading favorites...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          Text(
            controller.searchQuery.isNotEmpty
                ? 'No favorites found'
                : 'No favorites yet',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            controller.searchQuery.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Start adding movies to your favorites\nand they\'ll appear here',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (controller.searchQuery.isNotEmpty)
            ElevatedButton(
              onPressed: controller.clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Clear Search'),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.explore),
              label: const Text('Discover Movies'),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    if (controller.searchQuery.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search: "${controller.searchQuery}"',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          IconButton(
            onPressed: controller.clearSearch,
            icon: const Icon(Icons.clear, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Text(
            '${controller.filteredFavorites.length} ${controller.filteredFavorites.length == 1 ? 'Movie' : 'Movies'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (controller.searchQuery.isNotEmpty)
            Text(
              'of ${controller.favoritesCount} total',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return RefreshIndicator(
      onRefresh: controller.refreshFavorites,
      backgroundColor: Colors.grey[850],
      color: Colors.redAccent,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.filteredFavorites.length,
        itemBuilder: (context, index) {
          final movie = controller.filteredFavorites[index];
          return _buildMovieCard(movie);
        },
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToMovieDetail(movie),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[850],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Expanded(
          child: Stack(
            children: [
              Expanded(
                child: MovieBox(
                  movie: movie,
                  config: controller.config!,
                  fill: true,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => controller.removeFromFavorites(movie.id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchDialog() {
    final TextEditingController searchController = TextEditingController(
      text: controller.searchQuery,
    );

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Search Favorites',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter movie name...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          ),
          onSubmitted: (value) {
            controller.searchFavorites(value.trim());
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          ElevatedButton(
            onPressed: () {
              controller.searchFavorites(searchController.text.trim());
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _navigateToMovieDetail(Movie movie) {
    Get.toNamed('/movie-detail', arguments: [movie]);
  }
}
