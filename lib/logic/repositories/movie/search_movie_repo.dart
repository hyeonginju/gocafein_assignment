import 'dart:convert';
import 'package:gocafein/tools/config.dart';
import 'package:http/http.dart' as http;

class SearchMovieRepo {
  Future<Map<String, dynamic>> getMovieData(
      {required String keyWord, required int page}) async {
    Map<String, dynamic> datas = {};

    final response = await http.get(
      Uri.parse(
          'https://www.omdbapi.com/?apikey=${Config.openMovieApiKey}&s=$keyWord&$page=1&type=movie'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final int statusCode = response.statusCode;
    final responseData = json.decode(response.body);

    if (statusCode != 200) {
      datas["errorCode"] = statusCode;
      datas["data"] = responseData["Search"] ?? [];
      return datas;
    }

    datas["data"] = responseData["Search"] ?? [];
    return datas;
  }
}
