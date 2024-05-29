import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_bloc.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_event.dart';
import 'package:gocafein/logic/blocs/search_movie/search_movie_state.dart';
import 'package:gocafein/logic/models/movie/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gocafein/tools/global_variable.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  bool onSearch = true;
  String movieTitle = "";
  List<String> searchHistory = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    onFocusKeyBoard();
    loadSearchHistory();
  }

  void loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  void saveSearchTerm(String term) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.add(term);
    if (searchHistory.length > 10) {
      searchHistory.removeAt(0);
    }
    await prefs.setStringList('searchHistory', searchHistory);
  }

  void deleteSearchTerm(String term) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.remove(term);
    await prefs.setStringList('searchHistory', searchHistory);
    setState(() {});
  }

  void clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    setState(() {
      searchHistory = [];
    });
  }

  void tapTitle() {
    setState(() {
      onSearch = true;
      searchController.text = movieTitle;
    });
    onFocusKeyBoard();
  }

  void tapSearchIcon(value) {
    if (value.isNotEmpty) {
      setState(() {
        movieTitle = value;
        onSearch = !onSearch;
        searchController.text = value;
      });
    } else {
      setState(() {
        onSearch = true;
      });
    }
    if (onSearch) {
      onFocusKeyBoard();
    } else {
      saveSearchTerm(value);
    }
  }

  void onFocusKeyBoard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchFocusNode);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double statusBarHeight = mediaQuery.padding.top;
    final double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariable.mainColor,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 10, 0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: GlobalVariable.whiteColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Center(
          child: onSearch
              ? TextField(
                  focusNode: searchFocusNode,
                  onSubmitted: (value) => tapSearchIcon(value),
                  controller: searchController,
                  maxLength: 50,
                  maxLines: 1,
                  style: const TextStyle(
                      color: GlobalVariable.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: '',
                    border: InputBorder.none,
                    hintText: 'Enter movie title',
                    hintStyle: TextStyle(
                        color: GlobalVariable.greyColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                )
              : GestureDetector(
                  onTap: tapTitle,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              movieTitle,
                              style: const TextStyle(
                                  color: GlobalVariable.whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ],
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
              onPressed: () => tapSearchIcon(searchController.text),
            ),
          ),
        ],
      ),
      body: onSearch
          ? SearchScreen(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              searchHistory: searchHistory,
              tapSearchIcon: tapSearchIcon,
              onDelete: deleteSearchTerm,
              onClearAll: clearSearchHistory,
            )
          : BlocProvider(
              create: (context) => SearchMovieBloc(),
              child: ResultScreen(
                movieTitle: movieTitle,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                appBarHeight: appBarHeight,
                statusBarHeight: statusBarHeight,
              ),
            ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final List<String> searchHistory;
  final Function(String) tapSearchIcon;
  final Function(String) onDelete;
  final Function() onClearAll;

  const SearchScreen({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.searchHistory,
    required this.tapSearchIcon,
    required this.onDelete,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      color: GlobalVariable.mainColor,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GestureDetector(
                onTap: onClearAll,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('최근 검색어',
                        style: TextStyle(
                            color: GlobalVariable.whiteColor, fontSize: 16)),
                    Text(
                      '전체삭제',
                      style: TextStyle(
                        color: GlobalVariable.greyColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: searchHistory
                  .map(
                    (term) => ListTile(
                      title: Text(
                        term,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: GlobalVariable.whiteColor, fontSize: 18),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close,
                            color: GlobalVariable.greyColor),
                        onPressed: () => onDelete(term),
                      ),
                      onTap: () => tapSearchIcon(term),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final String movieTitle;
  final double screenHeight;
  final double screenWidth;
  final double appBarHeight;
  final double statusBarHeight;

  const ResultScreen({
    super.key,
    required this.movieTitle,
    required this.screenHeight,
    required this.screenWidth,
    required this.appBarHeight,
    required this.statusBarHeight,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    _scrollController.addListener(onScroll);
    super.initState();
  }

  void onScroll() async {
    if (_scrollController.position.pixels >=
            (_scrollController.position.maxScrollExtent * 0.9) &&
        context.read<SearchMovieBloc>().state is! SearchMovieLoading) {
      page++;
      context.read<SearchMovieBloc>().add(
            SearchMovie(
              keyWord: widget.movieTitle,
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
    return Container(
      width: widget.screenWidth,
      color: GlobalVariable.mainColor,
      child: Expanded(
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                width: widget.screenWidth,
                constraints: BoxConstraints(
                  minHeight: widget.screenHeight -
                      widget.appBarHeight -
                      widget.statusBarHeight,
                ),
                child: BlocBuilder<SearchMovieBloc, SearchMovieState>(
                    builder: (context, state) {
                  if (state is SearchMovieInitial) {
                    context.read<SearchMovieBloc>().add(
                          SearchMovie(
                            keyWord: widget.movieTitle,
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

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movieList.length +
                          (state is SearchMovieLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == movieList.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SearchMovieCard(
                          widget: widget,
                          movieData: movieList[index],
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ))),
    );
  }
}

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

    return Container(
      width: widget.screenWidth * 0.3,
      height: widget.screenWidth * 0.3 * 1.5,
      padding: const EdgeInsets.only(bottom: 20),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        movieData.Title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: GlobalVariable.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      movieData.Year,
                      style: const TextStyle(
                        color: GlobalVariable.greyColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire's world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth ...",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: GlobalVariable.whiteColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
