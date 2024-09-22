
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:movie_app/bloc/topRatedBloc/topRatedState.dart';
import '../../moduls/details_for_pages.dart';
import 'package:http/http.dart' as http;

class TopRatedLogic extends Cubit<Topratedstate> {
  TopRatedLogic() : super(InitTopRated());
  List<Post> posts = [];

  void getTopRated() async {
    emit(TopRatedLoading());
    try {
      // Fetch data from the API
      http.Response result = await http.get(
        Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=df7861568de66e24a1c2de6ab4900e1d"),
      );

      // Decode the JSON response body
      var data = jsonDecode(result.body);

      // Check if 'results' exists and is a list
      if (data['results'] != null && data['results'] is List) {
        List results = data['results'];

        // Clear the previous posts before adding new ones
        posts.clear();

        // Add posts by iterating over the results
        for (var element in results) {
          posts.add(Post(
            id: element['id'],
            original_title: element['original_title'],
            overview: element['overview'],
            release_date: element['release_date'],
            poster_path: element['poster_path'],
          ));
        }

        // Emit state after fetching posts
        emit(GetTopRated());
        emit(TopRatedLoaded(posts));
      } else {
        // Handle if 'results' key is missing or invalid
        emit(TopRatedError('Invalid API response'));
      }
    } catch (e) {
      // Handle any errors during the request or parsing
      emit(TopRatedError('Failed to fetch posts: $e'));
    }
  }
}


