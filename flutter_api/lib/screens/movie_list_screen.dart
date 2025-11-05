import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/tmdb_api.dart';
import '../utils/constants.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TMDBApi api = TMDBApi();
  List<dynamic> movies = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies({int page = 1}) async {
    setState(() => isLoading = true);
    try {
      final data = await api.getPopularMovies(page: page);
      setState(() {
        movies = data['results'];
        totalPages = data['total_pages'] ?? 1;
        currentPage = page;
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    loadMovies(page: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search for Your Movie!',
            onPressed: () {},
          ), 
        ]
      ),
      body: isLoading && movies.isEmpty
    ? const Center(child: CircularProgressIndicator())
    : Stack(
        children: [
          // MAIN CONTENT
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.1), // space for side arrows
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      final imageUrl =
                        '${ApiConstants.imageBaseUrl}${movie['poster_path']}';
                        
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                    const Center(
                                      child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  movie['title'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // PAGE NUMBER BAR AT BOTTOM
            //   Container(
            //     color: Colors.black54,
            //     padding: const EdgeInsets.symmetric(vertical: 8),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         ..._buildPageButtons(),
            //       ],
            //     ),
            //   ),
            ],
          ),

          // PREVIOUS BUTTON (LEFT CENTER)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              iconSize: 20,
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.black),
              ),
              onPressed:
                  currentPage > 1 ? () => goToPage(currentPage - 1) : null,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),

          // NEXT BUTTON (RIGHT CENTER)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              iconSize: 20,
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.black),
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

//   List<Widget> _buildPageButtons() {
//     const int maxButtons = 5; // visible buttons
//     int start = (currentPage - 2).clamp(1, totalPages);
//     int end = (start + maxButtons - 1).clamp(1, totalPages);

//     // Adjust start if we’re near the end
//     if (end - start < maxButtons - 1 && start > 1) {
//       start = (end - maxButtons + 1).clamp(1, totalPages);
//     }

//     return [
//       for (int i = start; i <= end; i++)
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 3),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: i == currentPage ? Colors.amber : Colors.grey[800],
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             ),
//             onPressed: () => goToPage(i),
//             child: Text(
//               '$i',
//               style: TextStyle(
//                   color: i == currentPage ? Colors.black : Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//     ];
//   }
}
