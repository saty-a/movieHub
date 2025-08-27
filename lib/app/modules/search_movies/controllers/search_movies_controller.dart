import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/dto/movie.dart';
import '../../../data/models/dto/configuration.dart';
import '../../../data/repository/tmdb_repository.dart';

class SearchMoviesController extends GetxController {
  final query = ''.obs;
  final isLoading = false.obs;
  final results = <Movie>[].obs;
  late final Configuration config;
  final searchController = TextEditingController();

  final _repo = TMDBApiRepository();
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    config = await _repo.getConfiguration();
  }

  void onQueryChanged(String q) {
    query.value = q.trim();
    _debounce?.cancel();
    if (q.isEmpty) {
      results.clear();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchMovies();
    });
  }

  Future<void> searchMovies() async {
    if (query.value.isEmpty) return;
    try {
      isLoading.value = true;
      final raw = await _repo.searchMovies(query.value);
      results.assignAll(raw.map((e) => Movie.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Search failed',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    query.value = '';
    results.clear();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
