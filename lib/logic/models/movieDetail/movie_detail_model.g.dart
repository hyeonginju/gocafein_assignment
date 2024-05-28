// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailModel _$MovieDetailModelFromJson(Map<String, dynamic> json) =>
    MovieDetailModel(
      Title: json['Title'] as String,
      Released: json['Released'] as String,
      Runtime: json['Runtime'] as String,
      Plot: json['Plot'] as String,
      Ratings: json['Ratings'] as List<dynamic>,
      BoxOffice: json['BoxOffice'] as String,
    );

Map<String, dynamic> _$MovieDetailModelToJson(MovieDetailModel instance) =>
    <String, dynamic>{
      'Title': instance.Title,
      'Released': instance.Released,
      'Runtime': instance.Runtime,
      'Plot': instance.Plot,
      'Ratings': instance.Ratings,
      'BoxOffice': instance.BoxOffice,
    };
