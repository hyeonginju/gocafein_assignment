import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/UI/screens/movie_detail.dart';
import 'package:gocafein/logic/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:gocafein/logic/models/movie/movie_model.dart';
import 'package:gocafein/tools/global_variable.dart';

class HomeMovieCard extends StatefulWidget {
  final MovieModel movie;
  final double movieCardWidth;
  final double moviePosterHeight;

  const HomeMovieCard({
    super.key,
    required this.movie,
    required this.movieCardWidth,
    required this.moviePosterHeight,
  });

  @override
  State<HomeMovieCard> createState() => _HomeMovieCardState();
}

class _HomeMovieCardState extends State<HomeMovieCard> {
  void goDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<MovieDetailBloc>(
            create: (context) => MovieDetailBloc(),
            child: MovieDetailScreen(movie: widget.movie)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = widget.movie.Poster.isNotEmpty &&
            (widget.movie.Poster.startsWith('http') ||
                widget.movie.Poster.startsWith('https'))
        ? widget.movie.Poster
        : 'https://via.placeholder.com/300x450.png?text=No+Image';

    return GestureDetector(
      onTap: goDetail,
      child: Container(
        decoration: BoxDecoration(
          color: GlobalVariable.homeCardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: widget.movieCardWidth,
              height: widget.moviePosterHeight,
              decoration: BoxDecoration(
                color: GlobalVariable.blackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: widget.movieCardWidth,
                  height: widget.moviePosterHeight,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/logos/no_image.png',
                      width: widget.movieCardWidth,
                      height: widget.moviePosterHeight,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(widget.movie.Title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: GlobalVariable.whiteColor,
                      fontSize: 16,
                      height: 25 / 16)),
            ),
            Text(widget.movie.Year,
                style: const TextStyle(
                    color: GlobalVariable.greyColor,
                    fontSize: 16,
                    height: 25 / 16)),
          ],
        ),
      ),
    );
  }
}
