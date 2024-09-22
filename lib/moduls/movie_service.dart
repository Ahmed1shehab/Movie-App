import 'dart:convert';

import 'details_for_individual.dart';
import 'package:http/http.dart'as http;
class MovieService {
  final String apiKey = 'df7861568de66e24a1c2de6ab4900e1d'; // Store your API key securely

  Future<Details> getMovieDetails(int movieId) async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Ensure required fields are present and handle any potential null values
        if (jsonData != null) {
          return Details.fromJson(jsonData);
        } else {
          throw Exception('No data found for the movie');
        }
      } else {
        throw Exception('Failed to load movie details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }
}
