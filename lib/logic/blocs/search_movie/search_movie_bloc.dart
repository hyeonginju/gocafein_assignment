import 'package:bloc/bloc.dart';
import 'package:gocafein/logic/models/movie/movie_model.dart';

import '../../repositories/movie/search_movie_repo.dart';
import 'search_movie_event.dart';
import 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  SearchMovieBloc() : super(SearchMovieInitial()) {
    List<MovieModel> movieDataList = [];

    on<IsSearchMovieEvent>((event, emit) async {
      try {
        emit(SearchMovieLoading());
        final responseData = await SearchMovieRepo().getMovieData(
          keyWord: event.keyWord,
          page: event.page,
        );
        if (responseData['errorCode'] != null) {
          return emit(
              SearchMovieFailure("${responseData['errorCode']} 영화 검색 실패 "));
        }

        Map<String, dynamic> bodyData = {"data": responseData["data"]};

        List<dynamic> list = await bodyData["data"];

        List<MovieModel> newData =
            list.map((e) => MovieModel.fromJson(e)).toList();
        movieDataList.addAll(newData);

        emit(SearchMovieSuccess(movieList: movieDataList));
      } catch (error) {
        emit(SearchMovieError('영화 검색 중 오류가 발생했습니다. $error'));
      }
    });
  }
}
