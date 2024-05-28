import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gocafein/tools/global_variable.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double imageWidth = screenWidth * 0.65;

    TextStyle whiteBold16 = const TextStyle(
      color: GlobalVariable.whiteColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariable.mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: GlobalVariable.whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 20),
        color: GlobalVariable.mainColor,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: [0.4, 1.0],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/logos/movie_poster_sample.png',
                          width: imageWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: screenWidth * 0.65 - imageWidth * 0.2 + 10,
                    child: Container(
                      width: screenWidth * 0.35 + imageWidth * 0.2 - 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 30),
                          Text(
                            'Boy Hood 12312 123 123123',
                            style:
                                whiteBold16.copyWith(fontSize: 20, height: 1.1),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            '1977.05.25',
                            style: whiteBold16,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '121분',
                            style: whiteBold16,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '1300만명',
                            style: whiteBold16,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '🍅 95%',
                            style: whiteBold16,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          const SizedBox(height: 10),
                          // Text(
                          //   '⭐️ 8.6',
                          //   style: whiteBold16,
                          //   overflow: TextOverflow.visible,
                          //   softWrap: true,
                          // ),
                        ],
                      ),
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
