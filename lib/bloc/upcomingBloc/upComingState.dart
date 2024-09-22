
import '../../moduls/details_for_pages.dart';

abstract class upComingstate{}

class InitupComing extends upComingstate{}

class GetupComing extends upComingstate{}
class upComingError extends upComingstate{
  final String message;

  upComingError(this.message);
}

class upComingLoading extends upComingstate {}

class upComingLoaded extends upComingstate {
  final List<Post> posts;

  upComingLoaded(this.posts);
}

