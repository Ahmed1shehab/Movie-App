
import '../../moduls/details_for_pages.dart';

abstract class Topratedstate{}

class InitTopRated extends Topratedstate{}

class GetTopRated extends Topratedstate{}
class TopRatedError extends Topratedstate{
  final String message;

  TopRatedError(this.message);
}

class TopRatedLoading extends Topratedstate {}

class TopRatedLoaded extends Topratedstate {
  final List<Post> posts;
  TopRatedLoaded(this.posts);
}

