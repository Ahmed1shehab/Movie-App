class LoveState {
  final List<Map<String, dynamic>> favoriteMovies;
  final bool isLoved;
  final String? error; // Add an optional error field

  LoveState({
    required this.favoriteMovies,
    required this.isLoved,
    this.error, // Initialize error field
  });
}
