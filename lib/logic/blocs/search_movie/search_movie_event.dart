abstract class SearchMovieEvent {}

class SearchMovie extends SearchMovieEvent {
  final String keyWord;
  final int page;

  SearchMovie({
    required this.keyWord,
    required this.page,
  });

  List<Object?> get props => [keyWord, page];
}
