import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/UI/widgets/home_animated_appbar.dart';
import 'package:gocafein/UI/widgets/home_movie_card.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_bloc.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_event.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_state.dart';
import 'package:gocafein/logic/models/movie/movie_model.dart';
import 'package:gocafein/tools/global_variable.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _exposureAppBar = true;
  int page = 1;

  @override
  void initState() {
    _scrollController.addListener(onScroll);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_exposureAppBar) {
          setState(() {
            _exposureAppBar = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_exposureAppBar) {
          setState(() {
            _exposureAppBar = true;
          });
        }
      }
    });
    super.initState();
  }

  void onScroll() async {
    if (_scrollController.position.pixels >=
            (_scrollController.position.maxScrollExtent * 0.9) &&
        context.read<SearchMovieBloc>().state is! SearchMovieLoading) {
      page++;
      context.read<SearchMovieBloc>().add(
            SearchMovie(
              keyWord: 'star',
              page: page,
            ),
          );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double statusBarHeight = mediaQuery.padding.top;
    final double screenwidth = mediaQuery.size.width;
    final double screenheight = mediaQuery.size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double movieCardWidth = (screenwidth / 2) - 20;
    final double movieCardHeight = ((screenwidth / 2) - 20) * 1.5 + 50;
    final double moviePosterHeight = ((screenwidth / 2) - 40) * 1.5;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: GlobalVariable.mainColor),
          Column(
            children: [
              HomeAnimatedAppBar(
                exposureAppBar: _exposureAppBar,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    width: screenwidth,
                    constraints: BoxConstraints(
                      minHeight: screenheight - appBarHeight - statusBarHeight,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    color: GlobalVariable.mainColor,
                    child: BlocBuilder<SearchMovieBloc, SearchMovieState>(
                      builder: (context, state) {
                        if (state is SearchMovieInitial) {
                          context.read<SearchMovieBloc>().add(
                                SearchMovie(
                                  keyWord: 'star',
                                  page: 1,
                                ),
                              );
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is SearchMovieSuccess ||
                            state is SearchMovieLoading) {
                          final List<MovieModel> movieList =
                              state.movieList.cast<MovieModel>();

                          return Column(
                            children: [
                              GridView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio:
                                      movieCardWidth / movieCardHeight,
                                ),
                                itemCount: movieList.length +
                                    (state is SearchMovieLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == movieList.length) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return HomeMovieCard(
                                    movie: movieList[index],
                                    movieCardWidth: movieCardWidth,
                                    moviePosterHeight: moviePosterHeight,
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (state is SearchMovieFailure) {
                          return Center(
                            child: Text(state.error,
                                style: const TextStyle(
                                    color: GlobalVariable.whiteColor)),
                          );
                        } else if (state is SearchMovieError) {
                          return Center(
                            child: Text(state.error,
                                style: const TextStyle(
                                    color: GlobalVariable.whiteColor)),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
