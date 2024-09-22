
import '../../moduls/details_for_pages.dart';

abstract class PostState{}

class InitPost extends PostState{}

class GetPost extends PostState{}
class PostError extends PostState{
  final String message;

  PostError(this.message);
}
class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

