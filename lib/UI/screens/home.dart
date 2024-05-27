import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_bloc.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_event.dart';
import 'package:gocafein/tools/global_variable.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _exposureAppBar = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    context.read<SearchMovieBloc>().add(IsSearchMovieEvent(
          keyWord: 'star',
          page: 1,
        ));

    _scrollController = ScrollController()
      ..addListener(() {
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    double screenwidth = mediaQuery.width;
    double screenheight = mediaQuery.height;
    double appBarHeight = AppBar().preferredSize.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double movieCardWidth = (screenwidth / 2) - 20;
    double movieCardHeight = ((screenwidth / 2) - 20) * 1.5 + 50;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: GlobalVariable.mainColor),
          Column(
            children: [
              AnimatedAppBar(exposureAppBar: _exposureAppBar),
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
                    child: Column(
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
                            childAspectRatio: movieCardWidth / movieCardHeight,
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return MovieCard();
                          },
                        ),
                      ],
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

class AnimatedAppBar extends StatelessWidget {
  const AnimatedAppBar({
    super.key,
    required bool exposureAppBar,
  }) : _exposureAppBar = exposureAppBar;

  final bool _exposureAppBar;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: GlobalVariable.mainColor,
        leading: const SizedBox(width: 30),
        title: const Center(
          child: Text(
            'Movie Finder',
            style: TextStyle(
              color: GlobalVariable.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: GlobalVariable.whiteColor,
            iconSize: 30,
            onPressed: () {
              // Navigate to the Search Screen
            },
          ),
        ],
      ),
      secondChild: const SizedBox.shrink(),
      crossFadeState: _exposureAppBar
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GlobalVariable.homeCardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: GlobalVariable.blackColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logos/movie_poster_sample.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Movie Title123123123123123',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: GlobalVariable.whiteColor,
                    fontSize: 16,
                    height: 25 / 16)),
          ),
          Text('2024.07.09',
              style: TextStyle(
                  color: GlobalVariable.greyColor,
                  fontSize: 16,
                  height: 25 / 16)),
        ],
      ),
    );
  }
}
