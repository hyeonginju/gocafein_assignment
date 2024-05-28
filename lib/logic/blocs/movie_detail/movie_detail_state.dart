abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailSuccess extends MovieDetailState {
  final Object detailData;

  MovieDetailSuccess({
    required this.detailData,
  });
}

class MovieDetailFailure extends MovieDetailState {
  final String error;

  MovieDetailFailure(this.error);
}

class MovieDetailError extends MovieDetailState {
  final String error;

  MovieDetailError(this.error);
}
