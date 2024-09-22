import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/loveBloc/LoveLogic.dart';
import '../../bloc/loveBloc/LoveState.dart';
import '../../components/cards.dart';
import '../../components/custom_icon_button.dart';
import '../HomeScreen/HomeScreen.dart';
import '../ProfilePage/ProfilePage.dart';
import '../Search/Search.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoveLogic()..fetchFavoriteMovies(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(27, 35, 48, 1), // Set scaffold background color
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Favourites',
            style: TextStyle(
              fontFamily: 'NerkoOne', // Update with the desired font family
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<LoveLogic, LoveState>(
            builder: (context, state) {
              if (state.error != null) {
                return Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (state.favoriteMovies.isEmpty) {
                return const Center(
                  child: Text(
                    'No favorite movies added.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return GridView.builder(
                itemCount: state.favoriteMovies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65, // Adjust this ratio to increase image height
                ),
                itemBuilder: (context, index) {
                  final movie = state.favoriteMovies[index];
                  final posterPath = movie['posterPath'];
                  final title = movie['title'] ?? 'Unknown Title';
                  final genre = movie['genre'] ?? 'Unknown Genre';

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostDetail(movieId: int.parse(movie['id'] ?? '0')),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color.fromRGBO(12, 16, 22, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15.0),
                              ),
                              child: posterPath != null && posterPath.isNotEmpty
                                  ? Image.network(
                                'https://image.tmdb.org/t/p/w500/$posterPath',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              )
                                  : const Center(
                                child: Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        genre,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    BlocBuilder<LoveLogic, LoveState>(
                                      builder: (context, loveState) {
                                        final isLoved = loveState.favoriteMovies
                                            .any((favMovie) => favMovie['id'] == movie['id']);
                                        return IconButton(
                                          icon: Icon(
                                            isLoved ? Icons.favorite : Icons.favorite_border,
                                            color: isLoved ? Colors.red : Colors.white,
                                          ),
                                          onPressed: () {
                                            context.read<LoveLogic>().toggleLove(movie['id'].toString());
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(12, 16, 22, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomIconButton(
                icon: Icons.home,
                color: Colors.white,
                size: 30,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var opacityAnimation = animation.drive(CurveTween(curve: Curves.easeInOut));
                        return FadeTransition(opacity: opacityAnimation, child: child);
                      },
                    ),
                  );
                },
              ),
              CustomIconButton(
                icon: Icons.search,
                color: Colors.white,
                size: 30,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const Search(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var opacityAnimation = animation.drive(CurveTween(curve: Curves.easeInOut));
                        return FadeTransition(opacity: opacityAnimation, child: child);
                      },
                    ),
                  );
                },
              ),
              CustomIconButton(
                icon: Icons.favorite_border,
                color: Colors.white,
                size: 30,
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const FavouritesPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = 0.0;
                        const end = 1.0;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end);
                        var opacityAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

                        return FadeTransition(opacity: opacityAnimation, child: child);
                      },
                    ),
                  );
                },
              ),
              CustomIconButton(
                icon: Icons.person_outline,
                color: Colors.white,
                size: 30,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>  ProfilePage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var opacityAnimation = animation.drive(CurveTween(curve: Curves.easeInOut));
                        return FadeTransition(opacity: opacityAnimation, child: child);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
