import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/nowPlayingBloc/nowPlayingLogic.dart';
import '../../bloc/nowPlayingBloc/nowPlayingState.dart';
import '../../bloc/postBloc/postLogic.dart';
import '../../bloc/postBloc/postState.dart';
import '../../bloc/upcomingBloc/upCOmingState.dart';
import '../../bloc/upcomingBloc/upComingLogic.dart';
import '../../components/back_btn.dart';
import '../../components/card_see_More.dart';

class SeeMore extends StatelessWidget {
  final Postlogic? postLogic;
  final Nowplayinglogic? nowplayingLogic;
  final upCominglogic? upComingLogic;
  final String title;

  const SeeMore({
    super.key,
    this.postLogic,
    this.nowplayingLogic,
    this.upComingLogic,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildBackButton(context),
            // Page title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontFamily: 'NerkoOne',
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
      ),
      backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
      body: Center(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (postLogic != null) {
      return BlocBuilder<Postlogic, PostState>(
        bloc: postLogic,
        builder: (context, state) {
          if (state is PostLoaded) {
            final posts = state.posts.take(18).toList(); // Limit to 10 items
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return buildCard(context,post.original_title, post.overview, post.poster_path, post.id);
              },
            );
          } else if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No posts available'));
        },
      );
    } else if (nowplayingLogic != null) {
      return BlocBuilder<Nowplayinglogic, Nowplayingstate>(
        bloc: nowplayingLogic,
        builder: (context, state) {
          if (state is NowplayingLoaded) {
            final nowPlayingMovies = state.posts.take(10).toList(); // Limit to 10 items
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1 / 1.5,
              ),
              itemCount: nowPlayingMovies.length,
              itemBuilder: (context, index) {
                final movie = nowPlayingMovies[index];
                return buildCard(context,movie.original_title, movie.overview, movie.poster_path, movie.id);
              },
            );
          } else if (state is NowplayingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NowplayingError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No now playing movies available'));
        },
      );
    }   else if (upComingLogic != null) {
      return BlocBuilder<upCominglogic, upComingstate>(
        bloc: upComingLogic,
        builder: (context, state) {
          if (state is upComingLoaded) {  // Check for upComingLoaded state
            final upcomingMovies = state.posts.take(10).toList(); // Limit to 10 items
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1 / 1.5,
              ),
              itemCount: upcomingMovies.length,
              itemBuilder: (context, index) {
                final movie = upcomingMovies[index];
                return buildCard(context, movie.original_title, movie.overview, movie.poster_path, movie.id);
              },
            );
          } else if (state is upComingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is upComingError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No upcoming movies available'));
        },
      );
    }

    else {
      return const Center(child: Text('No logic provided'));
    }
  }

}
