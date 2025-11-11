// widgets/movie_grid_widget.dart
import 'package:flutter/material.dart';

class MovieGridWidget extends StatelessWidget {
  final List<String> imageUrls;
  final int crossAxisCount;
  final double spacing;

  const MovieGridWidget({
    super.key,
    required this.imageUrls,
    this.crossAxisCount = 3,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 0.7,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
