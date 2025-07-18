import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayerPageState extends ChangeNotifier {
  VideoId? _videoId;
  ClosedCaptionTrackInfo? _trackInfo;
  UnmodifiableListView<ClosedCaptionTrackInfo>? _trackInfos;

  VideoId? get videoId => _videoId;
  ClosedCaptionTrackInfo? get trackInfo => _trackInfo;
  UnmodifiableListView<ClosedCaptionTrackInfo>? get trackInfos => _trackInfos;

  void updatePlayer(
    VideoId? videoId,
    ClosedCaptionTrackInfo? trackInfo,
    UnmodifiableListView<ClosedCaptionTrackInfo>? trackInfos,
  ) {
    _videoId = videoId;
    _trackInfo = trackInfo;
    _trackInfos = trackInfos;
    notifyListeners();
  }
}
