import 'package:flutter/material.dart';
import 'package:gocafein/UI/screens/movie_search.dart';
import 'package:gocafein/tools/global_variable.dart';

class NoMovieDataScreen extends StatelessWidget {
  const NoMovieDataScreen({
    super.key,
    required this.widget,
  });

  final ResultScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: widget.appBarHeight + widget.statusBarHeight),
      child: const Center(
        child: Text(
          '영화 정보가 없습니다.',
          style: TextStyle(
            color: GlobalVariable.whiteColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
