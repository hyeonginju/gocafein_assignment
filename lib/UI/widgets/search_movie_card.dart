import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/UI/screens/movie_detail.dart';
import 'package:gocafein/UI/screens/movie_search.dart';
import 'package:gocafein/logic/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:gocafein/logic/models/movie/movie_model.dart';
import 'package:gocafein/tools/global_variable.dart';

class SearchMovieCard extends StatelessWidget {
  const SearchMovieCard({
    super.key,
    required this.widget,
    required this.movieData,
  });

  final ResultScreen widget;
  final MovieModel movieData;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = movieData.Poster.isNotEmpty &&
            (movieData.Poster.startsWith('http') ||
                movieData.Poster.startsWith('https'))
        ? movieData.Poster
        : 'https://via.placeholder.com/300x450.png?text=No+Image';

    void goDetailScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<MovieDetailBloc>(
              create: (context) => MovieDetailBloc(),
              child: MovieDetailScreen(movie: movieData)),
        ),
      );
    }

    return GestureDetector(
      onTap: goDetailScreen,
      child: Container(
        color: Colors.transparent,
        width: widget.screenWidth * 0.3,
        height: widget.screenWidth * 0.3 * 1.5,
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: GlobalVariable.greyColor,
              ),
              height: widget.screenWidth * 0.3 * 1.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: widget.screenWidth * 0.25,
                  height: widget.screenWidth * 0.3 * 1.5,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/logos/no_image.png',
                      width: widget.screenWidth * 0.25,
                      height: widget.screenWidth * 0.3 * 1.5,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          movieData.Title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: GlobalVariable.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movieData.Year,
                    style: const TextStyle(
                      color: GlobalVariable.greyColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
