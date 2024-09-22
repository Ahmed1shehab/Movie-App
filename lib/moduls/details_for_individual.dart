class Details {
  final int id;
  final String originalTitle;
  final String overview;
  final String releaseDate;
  final String posterPath;
  final int budget;
  final List<String> genres;
  final double voteAverage;
  final String imdbId;


  Details({
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.budget,
    required this.genres,
    required this.voteAverage,
    required this.imdbId,

  });

  factory Details.fromJson(Map<String, dynamic> json) {
    const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

    return Details(
      id: json['id'] ?? 0,
      originalTitle: json['original_title'] ?? 'Unknown Title',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? 'Unknown Release Date',
      posterPath: json['poster_path'] != null ? '$baseImageUrl${json['poster_path']}' : 'No Poster Path',
      budget: json['budget'] ?? 0,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((genre) => genre['name'] as String)
          .toList(),
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      imdbId: json['imdb_id'] ?? 'No IMDB ID',
    );
  }
}
