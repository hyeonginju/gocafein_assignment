abstract class SearchMovieState {
  get movieList => null;
}

class SearchMovieInitial extends SearchMovieState {}

class SearchMovieLoading extends SearchMovieState {
  @override
  final List<Object> movieList;

  SearchMovieLoading({
    required this.movieList,
  });
}

class SearchMovieSuccess extends SearchMovieState {
  @override
  final List<Object> movieList;

  SearchMovieSuccess({
    required this.movieList,
  });
}

class SearchMovieFailure extends SearchMovieState {
  final String error;

  SearchMovieFailure(this.error);
}

class SearchMovieError extends SearchMovieState {
  final String error;

  SearchMovieError(this.error);
}
