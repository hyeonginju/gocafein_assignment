import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/logic/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:gocafein/logic/blocs/movie_detail/movie_detail_event.dart';
import 'package:gocafein/logic/blocs/movie_detail/movie_detail_state.dart';
import 'package:gocafein/logic/models/movie/movie_model.dart';
import 'package:gocafein/logic/models/movieDetail/movie_detail_model.dart';
import 'package:gocafein/tools/global_variable.dart';
import 'package:gocafein/tools/tools.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieModel movie;
  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;
    final String imageUrl = widget.movie.Poster.isNotEmpty &&
            (widget.movie.Poster.startsWith('http') ||
                widget.movie.Poster.startsWith('https'))
        ? widget.movie.Poster
        : 'https://via.placeholder.com/300x450.png?text=No+Image';

    TextStyle whiteBold16 = const TextStyle(
      color: GlobalVariable.whiteColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      height: 24 / 16,
    );

    TextStyle titleTextStyle = const TextStyle(
      color: GlobalVariable.whiteColor,
      fontWeight: FontWeight.w800,
      fontSize: 20,
      height: 24 / 20,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: GlobalVariable.whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: GlobalVariable.mainColor,
        height: screenHeight,
        child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
                builder: (context, state) {
              if (state is MovieDetailInitial) {
                context.read<MovieDetailBloc>().add(
                      IsMovieDetailEvent(
                        imdbID: widget.movie.imdbID,
                      ),
                    );
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is MovieDetailLoading) {
                return SizedBox(
                  height: screenHeight,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is MovieDetailSuccess) {
                MovieDetailModel detailData =
                    state.detailData as MovieDetailModel;
                String rottenTomatoesValue = '';
                List<dynamic> ratings = detailData.Ratings;
                for (var rating in ratings) {
                  if (rating['Source'] == 'Rotten Tomatoes') {
                    rottenTomatoesValue = rating['Value'];
                    break;
                  }
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: screenWidth * 1.5, // 이미지 높이 고정
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  stops: const [0.65, 1],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: ClipRRect(
                                child: Image.network(
                                  imageUrl,
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1),
                              width: screenWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: titleTextStyle,
                                      children: widget.movie.Title
                                          .split('')
                                          .map((char) => TextSpan(text: char))
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    Tools.convertReleased(detailData.Released),
                                    style: whiteBold16,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    Tools.convertRuntime(detailData.Runtime),
                                    style: whiteBold16,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    Tools.convertBoxOffice(
                                        detailData.BoxOffice),
                                    style: whiteBold16,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '🍅 $rottenTomatoesValue',
                                    style: whiteBold16,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (detailData.Plot == "N/A") ...[
                      Text('줄거리 정보가 없습니다.', style: whiteBold16),
                    ] else ...[
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: Row(
                          children: [
                            Flexible(
                              child: RichText(
                                maxLines: null,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: whiteBold16,
                                  children:
                                      detailData.Plot.split('').map((char) {
                                    return TextSpan(
                                      text: char,
                                      style: whiteBold16,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            })),
      ),
    );
  }
}
