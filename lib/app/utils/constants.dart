class Constants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String trendingMovies = '$baseUrl/trending/all/day?language=en-US';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ZWNiMjdhM2RhOTYzYmNhYWM3MDkwZjU1MjJjZTBjZCIsIm5iZiI6MTc1NTc4NTM2MC42NzEsInN1YiI6IjY4YTcyODkwOTcwYmRhYTU3NTNlOGI2NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.5BI0UblwDO6ex4VHOPemrtuBiqCJOoffxTjRVnG7eVc';
}
