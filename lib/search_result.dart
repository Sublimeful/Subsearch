import 'package:flutter/material.dart';
import 'package:subsearch/fallback_thumbnail.dart';
import 'package:subsearch/main.dart';
import 'package:subsearch/player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResultUI extends StatelessWidget {
  final Video result;

  const SearchResultUI({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MainWrapper(currentPage: PlayerPage(videoId: result.id)),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0),
              bottom: BorderSide(width: 1.0),
            ),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
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
                              : Text("No upload date"),
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
        ),
      ),
    );
  }
}
