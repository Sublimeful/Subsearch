import 'package:flutter/material.dart';
import 'package:subsearch/fallback_thumbnail.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResultUI extends StatelessWidget {
  final Video result;

  const SearchResultUI({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: [
          FallbackThumbnail(thumbnails: result.thumbnails),
          Expanded(
            child: Column(
              children: [
                Text(
                  result.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Text(result.engagement.viewCount.toString()),
                    (result.uploadDateRaw != null)
                        ? Text(result.uploadDateRaw!)
                        : Text("Unknown upload date"),
                  ],
                ),
                Text(result.author),
                Text(
                  result.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
