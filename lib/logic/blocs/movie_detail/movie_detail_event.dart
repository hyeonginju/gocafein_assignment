abstract class MovieDetailEvent {}

class IsMovieDetailEvent extends MovieDetailEvent {
  final String imdbID;

  IsMovieDetailEvent({
    required this.imdbID,
  });

  List<Object?> get props => [imdbID];
}
