import 'package:flutter/material.dart';
import 'package:gocafein/UI/screens/movie_search.dart';

class SearchDataLoadingScreen extends StatelessWidget {
  const SearchDataLoadingScreen({
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
        child: CircularProgressIndicator(),
      ),
    );
  }
}
