import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 5));
        },
        displacement: 50,
        edgeOffset: kToolbarHeight,
        child: PageView.builder(
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
      ),
    );
  }
}
