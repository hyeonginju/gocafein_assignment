// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      Title: json['Title'] as String,
      Year: json['Year'] as String,
      Poster: json['Poster'] as String,
      imdbID: json['imdbID'] as String,
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'Title': instance.Title,
      'Year': instance.Year,
      'Poster': instance.Poster,
      'imdbID': instance.imdbID,
    };
