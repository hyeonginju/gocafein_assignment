import 'package:json_annotation/json_annotation.dart';

part 'movie_detail_model.g.dart';

// flutter pub run build_runner build  => g파일 생성
@JsonSerializable()
class MovieDetailModel {
  final String Title;
  final String Released;
  final String Runtime;
  final String Plot;
  final List Ratings;
  final String BoxOffice;

  MovieDetailModel({
    required this.Title,
    required this.Released,
    required this.Runtime,
    required this.Plot,
    required this.Ratings,
    required this.BoxOffice,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailModelToJson(this);
}
