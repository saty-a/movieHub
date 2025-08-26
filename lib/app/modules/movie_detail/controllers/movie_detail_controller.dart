import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/app/data/models/dto/movie.dart';
import 'package:moviehub/app/data/repository/tmdb_repository.dart';
import 'package:moviehub/app/modules/liked_movies/controllers/liked_movies_controller.dart';
import '../../../data/models/dto/configuration.dart';
import '../../../utils/get_storage.dart';

class MovieDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Repository
  final TMDBApiRepository _repository = TMDBApiRepository();
  final StorageService _storageService = StorageService.instance;

  // Public properties
  late final Movie movie;
  late final TabController tabController;
  late final Configuration config;

  // Private observables for better performance
  final _isLoading = true.obs;
  final _movieDetails = Rxn<Movie>();
  final _selectedTabIndex = 0.obs;
  final _hasError = false.obs;
  final _isFavorite = false.obs;
  final _isPlaying = false.obs;
  final _errorMessage = ''.obs;

  // Getters to expose state
  bool get isLoading => _isLoading.value;

  Movie? get movieDetails => _movieDetails.value;

  int get selectedTabIndex => _selectedTabIndex.value;

  bool get hasError => _hasError.value;

  bool get isFavorite => _isFavorite.value;

  bool get isPlaying => _isPlaying.value;

  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
    _setupWorkers();
    loadMovieDetails();
  }

  void _initializeController() {
    // Get arguments from navigation
    final arguments = Get.arguments;
    if (arguments == null || arguments.length < 2) {
      _handleError('Invalid movie data provided');
      return;
    }

    movie = arguments[0] as Movie;
    config = arguments[1] as Configuration;

    tabController = TabController(
      length: movie.type == 'tv' ? 3 : 2,
      vsync: this,
    )..addListener(_handleTabChange);

    _checkFavoriteStatus();
  }

  void _setupWorkers() {
    // Debounce loading state changes
    debounce(_isLoading, (_) {
      if (!_isLoading.value && !_hasError.value) {
        _handleLoadingComplete();
      }
    }, time: Duration(milliseconds: 300));

    // Watch for tab changes
    ever(_selectedTabIndex, (index) {
      _handleTabIndexChange(index);
    });
  }

  void _handleTabChange() {
    _selectedTabIndex.value = tabController.index;
  }

  void _handleTabIndexChange(int index) {
    // Handle different tab actions
    switch (index) {
      case 0:
        // Main details tab
        break;
      case 1:
        // Reviews/Comments tab
        _loadReviews();
        break;
      case 2:
        // Episodes tab (for TV shows)
        if (movie.type == 'tv') {
          _loadEpisodes();
        }
        break;
    }
  }

  Future<void> loadMovieDetails() async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      if (!movie.details) {
        final response = await _repository.getDetails(movie.id, movie.type);
        _movieDetails.value = response;
      } else {
        _movieDetails.value = movie;
      }

      await _loadAdditionalData();
    } catch (e) {
      _handleError('Failed to load movie details: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadAdditionalData() async {
    try {
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Simulate network delay
    } catch (e) {
      debugPrint('Error loading additional data: $e');
    }
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _isLoading.value = false;

    debugPrint(" Error: $message");
  }

  void _handleLoadingComplete() {
    // Trigger any post-loading animations or state updates
    print('Movie details loaded successfully');
  }

  Future<void> retryLoading() async {
    await loadMovieDetails();
  }

  void _checkFavoriteStatus() async {
    _isFavorite.value = await isFavoriteMovie();
  }

  void toggleFavorite() {
    _isFavorite.value = !_isFavorite.value;
    _saveFavoriteStatus();
  }

  void _saveFavoriteStatus() {
    final favController = Get.find<LikedMoviesController>();
    if (movieDetails != null) {
      favController.toggleFavorite(movieDetails!);
    }
  }

  Future<bool> isFavoriteMovie() async {
    List<Movie> favorites = await _storageService.getFavorites();
    return favorites.any((movies) => movies.id == movie.id);
  }

  Future<void> playMovie() async {
    try {
      _isPlaying.value = true;
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      debugPrint("Playback Error: $e");
    } finally {
      _isPlaying.value = false;
    }
  }

  void downloadMovie() {
    Get.snackbar(
      'Download Started',
      '${movie.name} is being downloaded...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.download, color: Colors.white),
    );
  }

  void addToWatchlist() {
    Get.snackbar(
      'Added to Watchlist',
      '${movie.name} has been added to your watchlist',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.purple.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.playlist_add, color: Colors.white),
    );
  }

  void shareMovie() {
    Get.snackbar(
      'Sharing',
      'Sharing ${movie.name}...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.indigo.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.share, color: Colors.white),
    );
  }

  Future<void> _loadReviews() async {
    // Load movie reviews
    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 800));
      print('Reviews loaded for ${movie.name}');
    } catch (e) {
      print('Error loading reviews: $e');
    }
  }

  Future<void> _loadEpisodes() async {
    // Load TV show episodes
    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 800));
      print('Episodes loaded for ${movie.name}');
    } catch (e) {
      print('Error loading episodes: $e');
    }
  }

  void refreshData() {
    loadMovieDetails();
  }

  void updateMovieRating(double newRating) {
    if (_movieDetails.value != null) {
      _movieDetails.update((movie) {
        movie?.voteAverage = newRating;
      });
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    _movieDetails.value = null;
    super.onClose();
  }
}
