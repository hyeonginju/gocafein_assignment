import 'package:bloc/bloc.dart';
import 'package:gocafein/logic/models/movieDetail/movie_detail_model.dart';
import '../../repositories/movie/movie_detail_repo.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailModel movieDetailData = MovieDetailModel(
    Title: '',
    Released: '',
    Runtime: '',
    Plot: '',
    Ratings: [],
    BoxOffice: '',
  );

  String totalResults = '';

  MovieDetailBloc() : super(MovieDetailInitial()) {
    on<IsMovieDetailEvent>((event, emit) async {
      try {
        emit(MovieDetailLoading());
        final responseData = await MovieDetailRepo().getMovieDetailData(
          imdbID: event.imdbID,
        );

        if (responseData['errorCode'] != null) {
          return emit(MovieDetailFailure(
              "${responseData['errorCode']} 영화 상세정보 불러오기 실패 "));
        }

        Map<String, dynamic> bodyData = {"data": responseData["data"]};
        dynamic detailData = await bodyData["data"];
        movieDetailData = MovieDetailModel.fromJson(detailData);

        emit(MovieDetailSuccess(detailData: movieDetailData));
      } catch (error) {
        emit(MovieDetailError('영화 상세정보를 불러오는중 오류가 발생했습니다. $error'));
      }
    });
  }
}
