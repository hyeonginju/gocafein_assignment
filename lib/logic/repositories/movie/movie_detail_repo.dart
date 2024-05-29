import 'dart:convert';
import 'package:gocafein/tools/config.dart';
import 'package:http/http.dart' as http;

class MovieDetailRepo {
  Future<Map<String, dynamic>> getMovieDetailData(
      {required String imdbID}) async {
    Map<String, dynamic> datas = {};

    final response = await http.get(
      Uri.parse(
          'https://www.omdbapi.com/?apikey=${Config.openMovieApiKey}&i=$imdbID&plot=full'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final int statusCode = response.statusCode;
    final responseData = json.decode(response.body);

    if (statusCode != 200) {
      datas["errorCode"] = statusCode;
      datas["data"] = responseData ?? {};
      return datas;
    }

    datas["data"] = responseData ?? {};

    return datas;
  }
}
