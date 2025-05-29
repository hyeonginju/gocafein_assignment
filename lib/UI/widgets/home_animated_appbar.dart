import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/UI/screens/movie_search.dart';
import 'package:gocafein/logic/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:gocafein/tools/global_variable.dart';

class HomeAnimatedAppBar extends StatefulWidget {
  const HomeAnimatedAppBar({
    super.key,
    required bool exposureAppBar,
  }) : _exposureAppBar = exposureAppBar;

  final bool _exposureAppBar;

  @override
  State<HomeAnimatedAppBar> createState() => _HomeAnimatedAppBarState();
}

class _HomeAnimatedAppBarState extends State<HomeAnimatedAppBar> {
  void goSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<MovieDetailBloc>(
            create: (context) => MovieDetailBloc(), child: MovieSearchScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: GlobalVariable.mainColor,
        leading: const SizedBox(width: 0),
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Center(
            child: Text(
              'FlickPeek',
              style: TextStyle(
                color: GlobalVariable.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.search),
              color: GlobalVariable.whiteColor,
              iconSize: 30,
              onPressed: goSearchScreen,
            ),
          ),
        ],
      ),
      secondChild: const SizedBox.shrink(),
      crossFadeState: widget._exposureAppBar
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }
}
