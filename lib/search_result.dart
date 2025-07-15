import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResultUI extends StatelessWidget {
  final String title;
  final VideoId id;
  final String author;
  final DateTime? uploadDate;
  final Duration? duration;
  final ThumbnailSet thumbnails;

  const SearchResultUI({
    super.key,
    required this.title,
    required this.id,
    required this.author,
    required this.uploadDate,
    required this.duration,
    required this.thumbnails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: [
          _buildImageWithFallbacks(thumbnails),
          Expanded(
            child: Column(
              children: [Text(title, overflow: TextOverflow.ellipsis)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithFallbacks(ThumbnailSet thumbnails) {
    final urls = [
      thumbnails.standardResUrl,
      thumbnails.maxResUrl,
      thumbnails.highResUrl,
      thumbnails.mediumResUrl,
      thumbnails.lowResUrl,
    ];

    return Builder(
      builder: (context) {
        for (final url in urls) {
          try {
            return Image.network(
              url,
              width: 256.0,
              height: 144.0,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => throw Exception('Failed'),
            );
          } catch (_) {
            continue;
          }
        }
        return const Center(child: Icon(size: 144.0, Icons.broken_image));
      },
    );
  }
}
