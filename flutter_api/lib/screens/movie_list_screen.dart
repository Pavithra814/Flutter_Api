import 'package:flutter/material.dart';
import '../services/movie_api.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_appbar.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final MovieApi api = MovieApi();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> movies = [];
  bool isLoading = false;
  bool isSearching = false;
  String searchQuery = '';
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies({int pageNumber = 1}) async {
    setState(() => isLoading = true);
    try {
      final data = await api.getMovies(pageNumber: pageNumber);
      setState(() {
        movies = data['movies'];
        totalPages = data['totalPages'] ?? 1;
        currentPage = data['pageNumber'] ?? 1;
        isSearching = false;
      });
      _scrollController.jumpTo(0);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> searchMovies(String query, {int pageNumber = 1}) async {
    if (query.trim().isEmpty) {
      loadMovies();
      return;
    }

    setState(() {
      isLoading = true;
      isSearching = true;
      searchQuery = query;
    });

    try {
      final data = await api.searchMovies(query, pageNumber: pageNumber);
      setState(() {
        movies = data['movies'];
        totalPages = data['totalPages'] ?? 1;
        currentPage = data['pageNumber'] ?? 1;
      });
      _scrollController.jumpTo(0);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    isSearching ? searchMovies(searchQuery, pageNumber: page) : loadMovies(pageNumber: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(controller: _searchController, onSearch: searchMovies,showBackButton: false  ),
      body: isLoading && movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: movie['id'])),
                      ),
                    );
                  },
                ),

                // Pagination controls
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    iconSize: 20,
                    color: Colors.white,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.black54),
                    ),
                    onPressed: currentPage > 1 ? () => goToPage(currentPage - 1) : null,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    iconSize: 20,
                    color: Colors.white,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.black54),
                    ),
                    onPressed: currentPage < totalPages
                        ? () => goToPage(currentPage + 1)
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ],
            ),
    );
  }
}
