import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class FallbackThumbnail extends StatefulWidget {
  final ThumbnailSet thumbnails;

  const FallbackThumbnail({super.key, required this.thumbnails});

  @override
  State<FallbackThumbnail> createState() => _FallbackThumbnailState();
}

class _FallbackThumbnailState extends State<FallbackThumbnail> {
  late List<String> _imageUrls;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _imageUrls = [
      widget.thumbnails.standardResUrl,
      widget.thumbnails.maxResUrl,
      widget.thumbnails.highResUrl,
      widget.thumbnails.mediumResUrl,
      widget.thumbnails.lowResUrl,
    ];
  }

  void _tryNextImageUrl() {
    if (_currentIndex + 1 <= _imageUrls.length - 1) {
      setState(() {
        _currentIndex += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _imageUrls[_currentIndex],
      width: 256.0,
      height: 144.0,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorListener: (e) {
        if (mounted) _tryNextImageUrl();
      },
    );
  }
}
