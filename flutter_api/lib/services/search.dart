import 'tmdb_api.dart';

class SearchService {
  final TMDBApi api = TMDBApi();

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
