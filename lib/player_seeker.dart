import 'package:flutter/material.dart';

enum SeekDirection { FORWARD, BACKWARD }

class PlayerSeeker extends StatefulWidget {
  final void Function() onSeek;

  final SeekDirection seekDirection;

  const PlayerSeeker({
    super.key,
    required this.seekDirection,
    required this.onSeek,
  });

  @override
  State<PlayerSeeker> createState() => _PlayerSeeker();
}

class _PlayerSeeker extends State<PlayerSeeker> {
  double _opacity = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        if (widget.seekDirection == SeekDirection.FORWARD) {
          print("Seek Right");
        } else {
          print("Seek Left");
        }
        widget.onSeek();
        setState(() {
          _opacity = 1;
        });
      },
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _opacity,
          onEnd: () => setState(() {
            _opacity = 0;
          }),
          duration: Duration(milliseconds: 250),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.seekDirection == SeekDirection.FORWARD
                    ? Icons.arrow_right
                    : Icons.arrow_left,
                color: Colors.white,
                size: 54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
