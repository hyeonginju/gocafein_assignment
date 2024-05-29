import 'package:flutter/material.dart';
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
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  void _saveSearchTerm(String term) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.add(term);
    if (searchHistory.length > 10) {
      searchHistory.removeAt(0);
    }
    await prefs.setStringList('searchHistory', searchHistory);
  }

  void _deleteSearchTerm(String term) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.remove(term);
    await prefs.setStringList('searchHistory', searchHistory);
    setState(() {});
  }

  void _clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    setState(() {
      searchHistory = [];
    });
  }

  void changeSearchState(value) {
    if (value.isNotEmpty) {
      setState(() {
        movieTitle = value;
        onSearch = !onSearch;
      });
      if (onSearch) {
        onFocusKeyBoard();
      } else {
        _saveSearchTerm(value);
      }
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
    final size = MediaQuery.of(context).size;
    final screenHeigt = size.height;
    final screenWidth = size.width;

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
                  onSubmitted: (value) => changeSearchState(value),
                  controller: searchController,
                  maxLines: 1,
                  style: const TextStyle(color: GlobalVariable.whiteColor),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter movie title',
                    hintStyle: TextStyle(color: GlobalVariable.greyColor),
                  ),
                )
              : GestureDetector(
                  onTap: () => {
                    setState(() {
                      onSearch = true;
                    })
                  },
                  child: Text(
                    movieTitle,
                    style: const TextStyle(color: GlobalVariable.whiteColor),
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
              onPressed: () => changeSearchState(searchController.text),
            ),
          ),
        ],
      ),
      body: onSearch
          ? SearchScreen(
              screenHeigt: screenHeigt,
              screenWidth: screenWidth,
              searchHistory: searchHistory,
              onSearch: changeSearchState,
              onDelete: _deleteSearchTerm,
              onClearAll: _clearSearchHistory,
            )
          : ResultScreen(
              screenHeigt: screenHeigt,
              screenWidth: screenWidth,
            ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final double screenHeigt;
  final double screenWidth;
  final List<String> searchHistory;
  final Function(String) onSearch;
  final Function(String) onDelete;
  final Function() onClearAll;

  const SearchScreen({
    super.key,
    required this.screenHeigt,
    required this.screenWidth,
    required this.searchHistory,
    required this.onSearch,
    required this.onDelete,
    required this.onClearAll,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth,
      height: widget.screenHeigt,
      color: GlobalVariable.mainColor,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: widget.onClearAll,
                child: const Text(
                  '전체삭제',
                  style: TextStyle(
                    color: GlobalVariable.whiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: widget.searchHistory
                  .map(
                    (term) => ListTile(
                      title: Text(
                        term,
                        style:
                            const TextStyle(color: GlobalVariable.whiteColor),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close,
                            color: GlobalVariable.whiteColor),
                        onPressed: () => widget.onDelete(term),
                      ),
                      onTap: () => widget.onSearch(term),
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
  final double screenHeigt;
  final double screenWidth;

  const ResultScreen({
    super.key,
    required this.screenHeigt,
    required this.screenWidth,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Widget 2'),
    );
  }
}
