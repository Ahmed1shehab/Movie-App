import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/Pages/HomeScreen/see_more.dart';
import 'package:movie_app/Pages/ProfilePage/ProfilePage.dart';
import 'package:movie_app/Pages/Search/Search.dart';
import 'package:movie_app/bloc/nowPlayingBloc/nowPlayingLogic.dart';
import 'package:movie_app/bloc/upcomingBloc/upComingLogic.dart';
import '../../bloc/postBloc/postLogic.dart';
import '../../bloc/postBloc/postState.dart';
import '../../bloc/topRatedBloc/topRatedLogic.dart';
import '../../bloc/topRatedBloc/topRatedState.dart';
import '../../components/cards.dart';
import '../../components/custom_icon_button.dart';
import '../FavPage/Favourites.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Widget> buildPageIndicatorWidget(int itemCount, int currentPage) {
    return List<Widget>.generate(
      itemCount,
          (index) => _indicator(index == currentPage),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Postlogic()..getPost(),
        ),
        BlocProvider(
          create: (context) => TopRatedLogic()..getTopRated(),
        ),
        BlocProvider(
          create: (context) => Nowplayinglogic()..getNowPlaying(),
        ),
        BlocProvider(
          create: (context) => upCominglogic()..getupComing(),
        ),
      ],
      child: BlocBuilder<Postlogic, PostState>(
        builder: (context, postState) {

          final postLogic = BlocProvider.of<Postlogic>(context);
          final topRatedLogic = BlocProvider.of<TopRatedLogic>(context);
          final NowplayingLogic = BlocProvider.of<Nowplayinglogic>(context);
          final upComingLogic = BlocProvider.of<upCominglogic>(context);



          // Limit the posts to 10
          final limitedPosts = postLogic.posts.take(10).toList();
          final topRatedPosts = topRatedLogic.posts.take(10).toList();
          final nowPlayingPosts = NowplayingLogic.posts.take(10).toList();
          final upComingPosts = upComingLogic.posts.take(10).toList();


          bool isLoading = postLogic.state is PostLoading || topRatedLogic.state is TopRatedLoading;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NerkoOne',
                  fontSize: 40,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
            body: Stack(
              children: [
                SafeArea(
                  child: isLoading
                      ?
                  const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  )
                      :
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Top Rated",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 44,
                              fontFamily: 'NerkoOne',
                            ),
                          ),
                        ),
                        if (topRatedPosts.isNotEmpty)
                          //TopRated Section
                          CarouselSlider.builder(
                            itemCount: topRatedPosts.length,
                            itemBuilder: (context, index, realIndex) {
                              final post = topRatedPosts[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return PostDetail(movieId: post.id);
                                      },
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
                                //Carusal Top rated
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500/${post.poster_path}',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 300,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                            ),
                          ),


                        //Popular Section
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Popular',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'NerkoOne',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return SeeMore(title: 'Popular',postLogic: postLogic ); // Replace with your actual page and arguments
                                    },
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
                              child: RichText(
                                text: const TextSpan(
                                  text: 'See More',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontFamily: 'NerkoOne',
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: limitedPosts.length,
                            itemBuilder: (context, index) {
                              final post = limitedPosts[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: InkWell(
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500/${post.poster_path}',
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return PostDetail(movieId: post.id); // Replace with your actual page and arguments
                                          },
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
                                ),
                              );
                            },
                          ),
                        ),

                        //NowPlaying Section
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Now Playing',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'NerkoOne',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return SeeMore(title: 'Now Playing',nowplayingLogic:  NowplayingLogic); // Replace with your actual page and arguments
                                    },
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
                              child: RichText(
                                text: const TextSpan(
                                  text: 'See More',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontFamily: 'NerkoOne',
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: nowPlayingPosts.length,
                            itemBuilder: (context, index) {
                              final post = nowPlayingPosts[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: InkWell(
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500/${post.poster_path}',
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return PostDetail(movieId: post.id); // Replace with your actual page and arguments
                                          },
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
                                ),
                              );
                            },
                          ),
                        ),

                        //Upcoming Section
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Up Coming',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'NerkoOne',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return SeeMore(title: 'UpComing',upComingLogic:  upComingLogic); // Replace with your actual page and arguments
                                    },
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
                              child: RichText(
                                text: const TextSpan(
                                  text: 'See More',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontFamily: 'NerkoOne',
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upComingPosts.length,
                            itemBuilder: (context, index) {
                              final post = upComingPosts[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: InkWell(
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500/${post.poster_path}',
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return PostDetail(movieId: post.id); // Replace with your actual page and arguments
                                          },
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
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
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
        },
      ),
    );
  }
}
