import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

// flutter pub run build_runner build  => g파일 생성
@JsonSerializable()
class MovieModel {
  final String Title;
  final String Year;
  final String Poster;
  final int imdbID;

  MovieModel({
    required this.Title,
    required this.Year,
    required this.Poster,
    required this.imdbID,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}
