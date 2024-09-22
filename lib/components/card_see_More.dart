import 'package:flutter/material.dart';

import 'cards.dart';

Widget buildCard(BuildContext context, String title, String overview, String posterPath, int id) {
  return SingleChildScrollView(
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return PostDetail(movieId: id); // Use 'id' instead of 'movie.id'
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
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: const Color.fromRGBO(12, 16, 22, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: SizedBox(
                height: 180,
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/$posterPath',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.movie,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    overview,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
