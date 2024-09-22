import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/searchBloc/SearchLogic.dart';
import '../../bloc/searchBloc/SearchState.dart';
import '../../components/cards.dart'; // Assuming you have custom widgets here
import '../../components/custom_icon_button.dart';
import '../FavPage/Favourites.dart';
import '../HomeScreen/HomeScreen.dart';
import '../ProfilePage/ProfilePage.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 30, bottom: 20, right: 10),
        child: Column(
          children: [
            const SizedBox(height: 40,),
            //search
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                autofocus: false,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    BlocProvider.of<SearchLogic>(context).searchMovies(value);
                  }
                },
                style: const TextStyle(color: Color.fromRGBO(27, 35, 48, 1)), // Set the text color here
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: Color.fromRGBO(27, 35, 48, 1),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(27, 35, 48, 1),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // BlocBuilder for Search Results
            Expanded(
              child: BlocBuilder<SearchLogic, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  } else if (state is SearchResultsLoaded) {
                    if (state.searchResults.isEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 70,),
                            const Text('No results found...', style: TextStyle(color: Colors.white,fontSize: 40,fontFamily: 'NerkoOne')),
                            const SizedBox(height: 30,),
                            Image.asset('assets/images/NO.png')
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        final searchResult = state.searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetail(movieId: searchResult.id),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            height: 180,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(12, 16, 22, 1),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              children: [
                                // Display movie poster
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${searchResult.posterPath}',
                                    width: 120,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: Text('Image not available', style: TextStyle(color: Colors.white)));
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Display movie details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          searchResult.originalTitle ,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Expanded(
                                          child: Text(
                                            searchResult.overview ,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: Colors.red)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
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
    );
  }
}
