abstract class SearchMovieState {}

class SearchMovieInitial extends SearchMovieState {}

class SearchMovieLoading extends SearchMovieState {}

class SearchMovieSuccess extends SearchMovieState {
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
