class Movie {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String originalName;
  final String originalLanguage;
  final String type;
  final List<int> genreIds;
  final double popularity;
  final DateTime? releaseDate;
  late final double voteAverage;
  final int voteCount;
  final List<String> originCountry;
  final String? backdropPath;
  final bool adult;
  final bool video;
  final int? runtime;
  final int? episodes;
  final int? seasons;
  final bool details;

  Movie.fromJson(Map<String, dynamic> json, {medialType, this.details = false})
    : id = json['id'] ?? 0,
      name = json['name'] ?? json['title'] ?? 'Unknown Title',
      overview = json['overview'] ?? '',
      posterPath = json['poster_path'],
      originalName = json['original_name'] ?? json['original_title'] ?? 'Unknown Title',
      originalLanguage = json['original_language'] ?? 'en',
      type = json['media_type'] ?? medialType ?? 'movie',
      genreIds = List.castFrom<dynamic, int>(json['genre_ids'] ?? []),
      popularity = json['popularity'],
      releaseDate = DateTime.tryParse(
        json['first_air_date'] ?? json['release_date'],
      ),
      voteAverage = json['vote_average'].toDouble(),
      voteCount = json['vote_count'],
      originCountry = List.castFrom<dynamic, String>(
        json['origin_country'] ?? [],
      ),
      backdropPath = json['backdrop_path'],
      adult = json['adult'] ?? false,
      video = json['video'] ?? false,
      runtime = json['runtime'],
      episodes = json['number_of_episodes'],
      seasons = json['number_of_seasons'];

  toJson() {
    return {
      'id': id,
      'title': name,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate
          ?.toIso8601String(),
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'genre_ids': genreIds,
      'originalName': originalName,
      'original_language': originalLanguage,
      'video': video,
      'adult': adult,
      'type': type,
      'runtime': runtime,
      'episodes': episodes,
      'seasons': seasons,
    };
  }

  String getRuntime() {
    if (type == 'movie') {
      var hours = runtime! / 60,
          justHours = hours.floor(),
          minutes = ((hours - hours.floor()) * 60).floor();
      return '${justHours > 0 ? '${justHours}h' : ''}${minutes > 0 ? '${justHours > 0 ? ' ' : ''}${minutes}m' : ''}';
    }

    return episodes! < 20 ? '$episodes Episodes' : '$seasons Seasons';
  }
}
