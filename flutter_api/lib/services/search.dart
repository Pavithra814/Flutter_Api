import 'movie_api.dart';

class SearchService {
  final MovieApi api = MovieApi();

  /// Searches movies based on a query string
  Future<Map<String, dynamic>> searchMovies(String query) async {
    try {
      final data = await api.searchMovies(query);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
