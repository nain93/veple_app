import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VideoItem extends HookWidget {
  const VideoItem({super.key, required this.videoList, required this.index});

  final ValueNotifier<List<Color>> videoList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: videoList.value[index],
      child: Center(child: Text('scroll ${index + 1}')),
    );
  }
}
