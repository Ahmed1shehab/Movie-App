
import '../../moduls/details_for_pages.dart';

abstract class Nowplayingstate{}

class InitNowplaying extends Nowplayingstate{}

class GetNowplaying extends Nowplayingstate{}
class NowplayingError extends Nowplayingstate{
  final String message;

  NowplayingError(this.message);
}

class NowplayingLoading extends Nowplayingstate {}

class NowplayingLoaded extends Nowplayingstate {
  final List<Post> posts;
  NowplayingLoaded(this.posts);
}

