import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:veple/screens/home/widgets/video_item.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pageController = usePageController();
    var itemCount = useState(5);

    void onPageChanged(int page) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    }

    void onVideoFinished() {
      pageController.nextPage(
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      );
    }

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        scrollDirection: Axis.vertical,
        itemCount: itemCount.value,
        itemBuilder: (context, index) {
          return VideoItem(
            onVideoFinished: onVideoFinished,
            index: index,
          );
        },
      ),
    );
  }
}
