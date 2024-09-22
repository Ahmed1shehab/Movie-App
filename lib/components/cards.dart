import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/components/web_view_page.dart';
import '../bloc/loveBloc/LoveLogic.dart';
import '../bloc/loveBloc/LoveState.dart';
import '../bloc/movieDetailsBloc/MovieDetailsLogic.dart';
import '../bloc/movieDetailsBloc/MovieDetailState.dart';
import 'movie_ratings.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PostDetail extends StatelessWidget {
  final int movieId;

  const PostDetail({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsLogic()..getMovieDetails(movieId),
      child: BlocProvider(
        create: (context) => LoveLogic()..checkIfFavorite(movieId.toString()),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(17, 15, 38, 1),
          body: Stack(
            children: <Widget>[
              BlocBuilder<MovieDetailsLogic, MovieDetailsState>(
                builder: (context, state) {
                  if (state is MovieDetailsLoaded) {
                    final movie = state.movieDetails;
                    return Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Stack(
                            children: <Widget>[
                              // Poster Image with Gradient Overlay
                              Image.network(
                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(1),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 600, // Adjust this to match the height of the image
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          movie.originalTitle,
                                          style: const TextStyle(
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "NerkoOne",
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      BlocBuilder<LoveLogic, LoveState>(
                                        builder: (context, loveState) {
                                          return IconButton(
                                            icon: Icon(
                                              loveState.isLoved ? Icons.favorite : Icons.favorite_border,
                                              color: loveState.isLoved ? Colors.red : Colors.white,
                                              size: 40.0,
                                            ),
                                            onPressed: () {
                                              context.read<LoveLogic>().toggleLove(movieId.toString());
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Year: ${movie.releaseDate.substring(0, 4)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      fontFamily: "NerkoOne",
                                    ),
                                  ),
                                  MovieRating(voteAverage: movie.voteAverage),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Type:',
                                    style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "NerkoOne",
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: movie.genres.map((genre) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(color: const Color.fromRGBO(22, 11, 74, 1), width: 1.5),
                                          color: const Color.fromRGBO(11, 25, 41, 1),
                                        ),
                                        child: Text(
                                          genre,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 16.0),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Budget: ',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\$${movie.budget.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    'Description:',
                                    style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "NerkoOne",
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    movie.overview,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is MovieDetailsError) {
                    return Center(
                      child: Text(
                        'Failed to load movie details: ${state.message}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Positioned(
                top: 40, // Adjust this value based on your design
                left: 16, // Adjust this value based on your design
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BlocBuilder<MovieDetailsLogic, MovieDetailsState>(
            builder: (context, state) {
              if (state is MovieDetailsLoaded) {
                final movie = state.movieDetails;
                return Container(
                  color: const Color.fromRGBO(11, 25, 48, 1),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(26, 67, 115, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    child: const Text('Watch Now'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            url: "https://www.imdb.com/title/${movie.imdbId}",
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

