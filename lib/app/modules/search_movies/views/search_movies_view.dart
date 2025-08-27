import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/movie_box.dart';
import '../controllers/search_movies_controller.dart';

class SearchMoviesView extends GetView<SearchMoviesController> {
  const SearchMoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: _buildSearchField(c),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return _buildLoading();
        }
        if (c.query.value.isEmpty) {
          return _buildPrompt();
        }
        if (c.results.isEmpty) {
          return _buildNoResults(c);
        }
        return _buildResultsGrid(c);
      }),
    );
  }

  Widget _buildSearchField(SearchMoviesController c) {
    return Material(
      elevation: 3,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: c.searchController,
        autofocus: true,
        cursorColor: Colors.redAccent,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
          hintText: 'Search movies...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.redAccent.withOpacity(0.4),
              width: 1.3,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.redAccent,
            size: 26,
          ),
          suffixIcon: Obx(() {
            return c.query.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: c.clearSearch,
                  )
                : const SizedBox.shrink();
          }),
        ),
        onChanged: c.onQueryChanged,
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.redAccent),
    );
  }

  Widget _buildPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'Search for movies by title',
              style: TextStyle(color: Colors.grey[500], fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(SearchMoviesController c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'No results for "${c.query.value}"',
          style: TextStyle(color: Colors.grey[500], fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildResultsGrid(SearchMoviesController c) {
    return RefreshIndicator(
      color: Colors.redAccent,
      onRefresh: c.searchMovies,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: c.results.length,
        itemBuilder: (context, i) {
          final m = c.results[i];
          return MovieBox(movie: m, config: c.config, fill: true);
        },
      ),
    );
  }
}
