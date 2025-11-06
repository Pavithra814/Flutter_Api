import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class TMDBApi {
  Future<Map<String, dynamic>> getPopularMovies({int page = 1}) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}movie/popular?api_key=${ApiConstants.apiKey}&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  //search movies by query
  Future<Map<String, dynamic>> searchMovies( String query, {int page = 1}) async {
  final url = Uri.parse(
    '${ApiConstants.baseUrl}search/movie?api_key=${ApiConstants.apiKey}&query=$query&page=$page',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to search movies');
  }
}


}
