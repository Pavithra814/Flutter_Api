import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class MovieApi {
  // Get paginated movies
  Future<Map<String, dynamic>> getMovies({int pageNumber = 1, int pageSize = 12}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}paged?pageNumber=$pageNumber&pageSize=$pageSize');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch movies. Status code: ${response.statusCode}');
    }
  }

  // Search movies
  Future<Map<String, dynamic>> searchMovies(String query, {int pageNumber = 1, int pageSize = 10}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}search?query=$query&pageNumber=$pageNumber&pageSize=$pageSize');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to search movies');
    }
  }

  // Get single movie by ID
  Future<Map<String, dynamic>> getMovieById(int id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

}
