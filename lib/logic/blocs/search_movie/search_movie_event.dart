abstract class SearchMovieEvent {}

class IsSearchMovieEvent extends SearchMovieEvent {
  final String keyWord;
  final int page;

  IsSearchMovieEvent({
    required this.keyWord,
    required this.page,
  });

  List<Object?> get props => [keyWord, page];
}
