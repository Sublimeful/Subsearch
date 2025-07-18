import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ClosedCaptionAlertDialog extends StatelessWidget {
  final UnmodifiableListView<ClosedCaptionTrackInfo> trackInfos;
  final Function(ClosedCaptionTrackInfo?) onTrackInfoSelected;
  const ClosedCaptionAlertDialog({
    super.key,
    required this.trackInfos,
    required this.onTrackInfoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select closed captions"),
      content: SizedBox(
        width: 300,
        height: 300,
        child: ListView.builder(
          itemCount: trackInfos.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return ListTile(
                title: Text("No captions"),
                onTap: () => onTrackInfoSelected(null),
              );
            }
            ClosedCaptionTrackInfo trackInfo = trackInfos[index - 1];
            return ListTile(
              title: Text(trackInfo.language.name),
              onTap: () => onTrackInfoSelected(trackInfo),
            );
          },
        ),
      ),
    );
  }
}
