import 'dart:convert';
import 'package:bloc/bloc.dart';
import '../../moduls/details_for_individual.dart'; // Ensure the import path is correct
import 'package:http/http.dart' as http;
import 'SearchState.dart';

class SearchLogic extends Cubit<SearchState> {
  SearchLogic() : super(InitSearchState());

  Future<void> searchMovies(String query) async {
    // Prevent empty queries
    if (query.isEmpty) {
      emit(SearchError('Search query cannot be empty'));
      return;
    }
    emit(SearchLoading());

    try {
      // Fetch movies based on search query
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/search/movie?query=$query&api_key=df7861568de66e24a1c2de6ab4900e1d",
        ),
      );

      print('Response status: ${response.statusCode}'); // Debugging output

      if (response.statusCode == 200) {
        // Decode the JSON response body
        final data = jsonDecode(response.body);

        // Parse the search results into a list of Details objects
        List<Details> searchResults = [];
        if (data['results'] != null && data['results'] is List) {
          searchResults = (data['results'] as List).map((movie) {
            return Details(
              id: movie['id'],
              originalTitle: movie['original_title'] ?? 'No Title',
              overview: movie['overview'] ?? 'No Overview',
              releaseDate: movie['release_date'] ?? 'No Release Date',
              posterPath: movie['poster_path'] != null
                  ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                  : 'No Poster Path',
              budget: 0, // Not provided in search results
              genres: [], // Update genre logic if necessary
              voteAverage: (movie['vote_average'] ?? 0.0).toDouble(),
              imdbId: movie['imdb_id'] ?? 'No IMDB ID',
            );
          }).toList();
        }

        print('Results found: ${searchResults.length}'); // Debugging output
        emit(SearchResultsLoaded(searchResults));
      } else {
        emit(SearchError('Failed to search movies. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      print('Error during search: $e'); // Debugging output
      emit(SearchError('Failed to search movies: $e'));
    }
  }
}
