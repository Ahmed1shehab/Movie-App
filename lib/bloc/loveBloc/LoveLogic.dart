import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../moduls/movie_service.dart';
import 'LoveState.dart';

class LoveLogic extends Cubit<LoveState> {
  LoveLogic() : super(LoveState(favoriteMovies: [], isLoved: false));

  // Fetch all favorite movies for the user
  Future<void> fetchFavoriteMovies() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(LoveState(favoriteMovies: [], isLoved: false, error: 'User not logged in'));
        return;
      }

      final favoritesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      final favoriteMovies = favoritesSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,  // Store document ID as movie ID
          'title': data['title'] ?? 'Unknown Title',
          'posterPath': data['posterPath'] ?? '',
          'genre': data['genre'] ?? 'Unknown Genre',
          'releaseDate': data['releaseDate'] ?? 'Unknown Release Date',
          'overview': data['overview'] ?? 'No Overview',
          'voteAverage': data['voteAverage'] ?? 0.0,
          // Add other fields as necessary
        };
      }).toList();

      emit(LoveState(favoriteMovies: favoriteMovies, isLoved: state.isLoved));
    } catch (e) {
      emit(LoveState(favoriteMovies: state.favoriteMovies, isLoved: false, error: 'Failed to fetch favorite movies: $e'));
    }
  }

  Future<void> checkIfFavorite(String movieId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(LoveState(favoriteMovies: state.favoriteMovies, isLoved: false, error: 'User not logged in'));
        return;
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(movieId)
          .get();

      emit(LoveState(
        favoriteMovies: state.favoriteMovies,
        isLoved: docSnapshot.exists,
      ));
    } catch (e) {
      emit(LoveState(favoriteMovies: state.favoriteMovies, isLoved: false, error: 'Failed to check if favorite: $e'));
    }
  }

  Future<void> toggleLove(String movieId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(LoveState(favoriteMovies: state.favoriteMovies, isLoved: false, error: 'User not logged in'));
        return;
      }

      final movieDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(movieId);

      final docSnapshot = await movieDocRef.get();

      if (docSnapshot.exists) {
        // Remove from favorites
        await movieDocRef.delete();
        emit(LoveState(favoriteMovies: state.favoriteMovies, isLoved: false));
      } else {
        // Fetch movie details using the MovieService
        final movieDetails = await MovieService().getMovieDetails(int.parse(movieId));

        // Store comprehensive movie details
        await movieDocRef.set({
          'title': movieDetails.originalTitle,
          'posterPath': movieDetails.posterPath,
          'genre': movieDetails.genres.join(', '),
          'releaseDate': movieDetails.releaseDate,
          'overview': movieDetails.overview,
          'voteAverage': movieDetails.voteAverage,
          // Add other fields as necessary
        });

        emit(LoveState(favoriteMovies: state.favoriteMovies, isLoved: true));
      }

      // Fetch updated list of favorite movies after toggling
      fetchFavoriteMovies();
    } catch (e) {
      emit(LoveState(favoriteMovies: state.favoriteMovies, isLoved: false, error: 'Failed to toggle favorite: $e'));
    }
  }
}
