import 'package:flutter/material.dart';
import 'package:veple/utils/assets.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoItem extends StatefulWidget {
  const VideoItem(
      {super.key, required this.onVideoFinished, required this.index});
  final Function onVideoFinished;
  final int index;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem>
    with SingleTickerProviderStateMixin {
  final _videoPlayerController =
      VideoPlayerController.asset(Assets.sampleVideo);

  late final AnimationController _animateController;

  var _isPaused = false;

  void _initVideoPlayer() {
    _videoPlayerController.initialize().then((_) {
      setState(() {});
      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.position >=
            _videoPlayerController.value.duration) {
          widget.onVideoFinished();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animateController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleVideoPlay() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
        _animateController.reverse();
        setState(() {
          _isPaused = true;
        });
      } else {
        _videoPlayerController.play();
        _animateController.forward();
        setState(() {
          _isPaused = false;
        });
      }
    }

    return VisibilityDetector(
      key: Key('${widget.index}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1 &&
            !_videoPlayerController.value.isPlaying &&
            !_isPaused) {
          _videoPlayerController.play();
        }
      },
      child: Stack(children: [
        Positioned.fill(
          child: _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : const SizedBox(),
        ),
        Positioned.fill(
          child: GestureDetector(onTap: handleVideoPlay),
        ),
        Positioned.fill(
            child: AnimatedBuilder(
          animation: _animateController,
          builder: (context, child) {
            return Transform.scale(
              scale: _animateController.value,
              child: child,
            );
          },
          child: AnimatedOpacity(
            opacity: _isPaused ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 80.0,
            ),
          ),
        )),
      ]),
    );
  }
}
