import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:veple/screens/home/widgets/video_item.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var videoList = useState([
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.teal,
    ]);

    var pageController = usePageController();

    void onPageChanged(int page) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );

      if (page == videoList.value.length - 1) {
        videoList.value = [...videoList.value, ...videoList.value];
      }
    }

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        scrollDirection: Axis.vertical,
        itemCount: videoList.value.length,
        itemBuilder: (context, index) {
          return VideoItem(
            videoList: videoList,
            index: index,
          );
        },
      ),
    );
  }
}
