import 'package:flutter/material.dart';
import 'package:subsearch/fallback_thumbnail.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResultUI extends StatelessWidget {
  final Video result;

  const SearchResultUI({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          FallbackThumbnail(thumbnails: result.thumbnails),
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    result.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Text("${result.engagement.viewCount} views"),
                      Icon(Icons.circle, size: 6),
                      (result.uploadDateRaw != null)
                          ? Text(result.uploadDateRaw!)
                          : Text("Unknown upload date"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Author: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          result.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    result.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
