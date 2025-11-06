import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import '../styles/rich_text.dart';

class MovieDetailScreen extends StatelessWidget {
  final dynamic movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = '${ApiConstants.imageBaseUrl}${movie['poster_path']}';

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title'] ?? 'Movie Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE — IMAGE
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 50),

            // RIGHT SIDE — MOVIE DETAILS
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoText(
                    label: "Title",
                    value: movie['title'] ?? 'Movie Details',
                    fontSize: 22,
                  ),
                  const SizedBox(height: 20),

                  InfoText(
                    label: "Rating",
                    value: movie['vote_average'].toString(),
                  ),
                  const SizedBox(height: 20),

                  InfoText(
                    label: "Release Date",
                    value: movie['release_date'] ?? 'Unknown',
                  ),
                  const SizedBox(height: 20),

                  // OVERVIEW
                  InfoText(
                    label: "Overview",
                    value: movie['overview'] ?? 'No description available.',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
