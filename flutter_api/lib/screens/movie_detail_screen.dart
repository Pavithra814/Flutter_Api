import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';

class MovieDetailScreen extends StatelessWidget {
  final dynamic movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
      '${ApiConstants.imageBaseUrl}${movie['poster_path']}';
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'] ?? 'Movie Details')),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
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

      const SizedBox(width: 20),

      // RIGHT SIDE — DETAILS
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie['title'] ?? 'Movie Details',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Rating: ${movie['vote_average']}',
              style: const TextStyle(fontSize: 16,),
            ),
            const SizedBox(height: 20),

            Text(
              'Release Date: ${movie['release_date'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 0),

            // GENRES
            if (movie['genres'] != null)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var genre in movie['genres'])
                    Chip(
                      label: Text(genre['name']),
                      backgroundColor: Colors.blue.shade50,
                    ),
                ],
              ),
            const SizedBox(height: 20),

            // OVERVIEW
            Text(
              movie['overview'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            // EXTRA INFO
            // Text(
            //   'Production Companies:',
            //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 6),
            // if (movie['production_companies'] != null)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       for (var company in movie['production_companies'])
            //         Text(
            //           '- ${company['name']}',
            //           style: const TextStyle(fontSize: 14),
            //         ),
            //     ],
            //   ),
            const SizedBox(height: 20),

            // Text(
            //   'Countries: ${movie['production_countries']?.map((c) => c['name']).join(', ') ?? 'Unknown'}',
            //   style: const TextStyle(fontSize: 16),
            // ),
          ],
        ),
      ),
    ],
  ),
));
  }}