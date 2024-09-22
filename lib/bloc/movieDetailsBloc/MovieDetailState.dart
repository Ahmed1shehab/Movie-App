import '../../moduls/details_for_individual.dart';

abstract class MovieDetailsState {}

class InitMovieDetails extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final Details movieDetails;
  MovieDetailsLoaded(this.movieDetails);
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  MovieDetailsError(this.message);
}