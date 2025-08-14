import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsearch/closed_caption_alert_dialog.dart';
import 'package:subsearch/main_state.dart';
import 'package:subsearch/player_seeker.dart';
import 'package:subsearch/player_state.dart';
import 'package:subsearch/utils/youtube_captions.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late YoutubePlayerController _controller;
  ClosedCaptionTrackInfo? _trackInfo;
  List<Caption>? _captionList;
  String? _captionText;
  double _captionsYOffset = 20;
  late PlayerPageState _state;
  late VoidCallback _stateListener;

  int _binarySearchEarliestCaption(double positionInSeconds) {
    if (_captionList == null || _captionList!.isEmpty) return -1;
    int l = 0;
    int r = _captionList!.length - 1;
    int resultIndex = -1;

    while (l <= r) {
      int m = l + (r - l) ~/ 2;
      Caption c = _captionList![m];

      if (positionInSeconds < c.start) {
        r = m - 1;
      } else if (positionInSeconds > c.end) {
        l = m + 1;
      } else {
        resultIndex = m;
        r = m - 1;
      }
    }

    return resultIndex;
  }

  int _binarySearchLatestCaption(double positionInSeconds) {
    if (_captionList == null || _captionList!.isEmpty) return -1;
    int l = 0;
    int r = _captionList!.length - 1;
    int resultIndex = -1;

    while (l <= r) {
      int m = l + (r - l) ~/ 2;
      Caption c = _captionList![m];

      if (positionInSeconds < c.start) {
        r = m - 1;
      } else if (positionInSeconds > c.end) {
        l = m + 1;
      } else {
        resultIndex = m;
        l = m + 1;
      }
    }

    return resultIndex;
  }

  void _listener() {
    // Hide/Show navbar based on fullscreen
    if (_controller.value.isFullScreen) {
      Provider.of<MainState>(context, listen: false).hideNavigationBar();
    } else {
      Provider.of<MainState>(context, listen: false).showNavigationBar();
    }

    // Change caption position based on controls visibility and fullscreen
    if (_controller.value.isFullScreen && _controller.value.isControlsVisible) {
      setState(() {
        _captionsYOffset = 60;
      });
    } else {
      setState(() {
        _captionsYOffset = 30;
      });
    }

    if (_captionList == null) return;

    Duration position = _controller.value.position;

    double positionInSeconds = position.inMilliseconds / 1000.0;

    int earliestCaptionIndex = _binarySearchEarliestCaption(positionInSeconds);
    int latestCaptionIndex = _binarySearchLatestCaption(positionInSeconds);

    String? prevCaptionText = _captionText;

    if (earliestCaptionIndex == -1 || latestCaptionIndex == -1) {
      _captionText = null;
    } else {
      List<Caption> slice = _captionList!.sublist(
        earliestCaptionIndex,
        latestCaptionIndex + 1,
      );
      _captionText = slice
          .where(
            (c) => positionInSeconds >= c.start && positionInSeconds <= c.end,
          )
          .map((c) => c.text)
          .join("\n");
    }

    if (prevCaptionText != _captionText) {
      setState(() {});
    }
  }

  void _updateTrack(VideoId videoId) async {
    if (_trackInfo == null) {
      _captionList = null;
      _captionText = null;
      return;
    }
    YouTubeTranscriptFetcher fetcher = YouTubeTranscriptFetcher();
    String captionXml = await fetcher.fetchCaptions(
      "https://www.youtube.com/watch?v=$videoId",
      languageCode: _trackInfo!.language.code,
    );

    _captionList = CaptionParser.parseXml(captionXml);
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: "",
      flags: YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: false,
        hideThumbnail: true,
        disableDragSeek: true,
      ),
    );

    _state = Provider.of<PlayerPageState>(context, listen: false);

    // Manually listen to changes
    _stateListener = () {
      if (_state.videoId != null) {
        _controller.load(_state.videoId!.value);
        if (_state.trackInfo != _trackInfo) {
          setState(() {
            _trackInfo = _state.trackInfo;
            _updateTrack(_state.videoId!);
          });
        }
      }
    };
    _state.addListener(_stateListener);
  }

  @override
  void dispose() {
    // Remove listeners to avoid leaks
    _state.removeListener(_stateListener);
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Consumer<PlayerPageState>(
              builder: (context, state, child) => YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                  controlsTimeOut: Duration(days: 365),
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                    state.trackInfos != null
                        ? IconButton(
                            icon: Icon(Icons.subtitles),
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ClosedCaptionAlertDialog(
                                    trackInfos: state.trackInfos!,
                                    onTrackInfoSelected: (trackInfo) {
                                      Navigator.pop(context);
                                      if (state.videoId == null) return;
                                      setState(() {
                                        _trackInfo = trackInfo;
                                        _updateTrack(state.videoId!);
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          )
                        : Icon(Icons.subtitles_off, color: Colors.white),
                    PlaybackSpeedButton(),
                    FullScreenButton(),
                  ],
                  onReady: () => _controller.addListener(_listener),
                ),
                builder: (context, player) {
                  return player;
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: PlayerSeeker(
                    seekDirection: SeekDirection.BACKWARD,
                    onSeek: () {
                      _controller.seekTo(
                        _controller.value.position - Duration(seconds: 5),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: PlayerSeeker(
                    seekDirection: SeekDirection.FORWARD,
                    onSeek: () {
                      _controller.seekTo(
                        _controller.value.position + Duration(seconds: 5),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(bottom: _captionsYOffset),
          child: SelectableText(
            _captionText ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.yellow,
              shadows: [
                Shadow(
                  // bottomLeft
                  offset: Offset(-0.5, -0.5),
                  color: Colors.black,
                ),
                Shadow(
                  // bottomRight
                  offset: Offset(0.5, -0.5),
                  color: Colors.black,
                ),
                Shadow(
                  // topRight
                  offset: Offset(0.5, 0.5),
                  color: Colors.black,
                ),
                Shadow(
                  // topLeft
                  offset: Offset(-0.5, 0.5),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
