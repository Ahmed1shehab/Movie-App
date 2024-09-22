import 'dart:convert';
import 'package:bloc/bloc.dart';
import '../../moduls/details_for_individual.dart'; // Update to correct file structure
import 'package:http/http.dart' as http;

import 'MovieDetailState.dart';

class MovieDetailsLogic extends Cubit<MovieDetailsState> {
  MovieDetailsLogic() : super(InitMovieDetails());

  Future<void> getMovieDetails(int movieId) async {
    try {
      // Fetch movie details by movie ID
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId?api_key=df7861568de66e24a1c2de6ab4900e1d",
        ),
      );

      // Check for successful response
      if (response.statusCode == 200) {
        // Decode the JSON response body
        final data = jsonDecode(response.body);

        // Extract the genres as a list of strings
        List<String> genres = [];
        if (data['genres'] != null && data['genres'] is List) {
          genres = (data['genres'] as List).map((genre) => genre['name'].toString()).toList();
        }

        // Create a Details object from the fetched data
        final movieDetails = Details(
          id: data['id'],
          originalTitle: data['original_title'],
          overview: data['overview'],
          releaseDate: data['release_date'],
          posterPath: data['poster_path'],
          budget: data['budget'],
          genres: genres,  // Pass the list of genres
          voteAverage: (data['vote_average'] ?? 0.0).toDouble(),
          imdbId: data['imdb_id'] ?? 'No IMDB ID',
        );

        // Emit the loaded state with the movie details
        emit(MovieDetailsLoaded(movieDetails));
      } else {
        // Emit error state if the response status code is not 200
        emit(MovieDetailsError('Failed to fetch movie details. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      // Emit error state in case of failure
      emit(MovieDetailsError('Failed to fetch movie details: $e'));
    }
  }
}
