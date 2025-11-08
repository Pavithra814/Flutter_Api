import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/movie_api.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieApi api = MovieApi();
  Map<String, dynamic>? movie;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMovie();
  }

  Future<void> loadMovie() async {
    try {
      final data = await api.getMovieById(widget.movieId);
      setState(() {
        movie = data;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (movie == null) {
      return const Scaffold(
        body: Center(child: Text('Movie not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.white),
  title: Text(
    movie!['title'],
    style: const TextStyle(color: Colors.white),
  ),
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: movie!['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 30),

            // DETAILS
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoText('Title', movie!['title']),
                  infoText('Director', movie!['director']),
                  infoText('Lead Actor', movie!['leadActor']),
                  infoText('Lead Actress', movie!['leadActress']),
                  infoText('Supporting Actors', movie!['supportingActors']),
                  infoText('Genres', movie!['genres']),
                  infoText('Language', movie!['language']),
                  infoText('Release Date', movie!['releaseDate']),
                  infoText('Rating', movie!['audienceRating'].toString()),
                  infoText('Audience Count', movie!['audienceCount'].toString()),
                  infoText('Runtime', '${movie!['runtimeMinutes']} min'),
                  infoText('Period', movie!['period']),
                  const SizedBox(height: 20),
                  const Text(
                    'Story Line:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(movie!['storyLine']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}
