
import 'package:flutter/material.dart';

class MovieRating extends StatelessWidget {
  final double voteAverage;

  const MovieRating({super.key, required this.voteAverage});

  List<Widget> _buildStarRating() {
    // Calculate the number of filled stars
    int fullStars = (voteAverage / 2).floor();
    // Check if there's a half star
    bool hasHalfStar = (voteAverage / 2 - fullStars) >= 0.5;
    // Calculate remaining empty stars
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.yellow));
    }

    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.yellow));
    }

    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.grey));
    }

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ..._buildStarRating(),
        const SizedBox(width: 4.0),
         Text(
          voteAverage.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
