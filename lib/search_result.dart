import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsearch/closed_caption_alert_dialog.dart';
import 'package:subsearch/fallback_thumbnail.dart';
import 'package:subsearch/main_state.dart';
import 'package:subsearch/player_state.dart';
import 'package:subsearch/utils/youtube.dart';
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              UnmodifiableListView<ClosedCaptionTrackInfo>? trackInfos;

              return StatefulBuilder(
                builder: (context, setState) {
                  if (trackInfos == null) {
                    Youtube.getTrackInfos(result.id).then((resTrackInfos) {
                      if (!context.mounted) return;
                      setState(() {
                        trackInfos = resTrackInfos;
                      });
                    });

                    return AlertDialog(
                      title: Text("Select closed captions"),
                      content: SizedBox(
                        width: 300,
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  return ClosedCaptionAlertDialog(
                    trackInfos: trackInfos!,
                    onTrackInfoSelected: (trackInfo) {
                      Provider.of<PlayerPageState>(
                        context,
                        listen: false,
                      ).updatePlayer(result.id, trackInfo, trackInfos);
                      Provider.of<MainState>(
                        context,
                        listen: false,
                      ).updatePageIndex(0);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
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
