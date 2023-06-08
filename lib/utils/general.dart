import 'package:flutter/material.dart';

class General {
  const General._();
  static General instance = const General._();

  void showBottomSheet(
    BuildContext context,
    Widget builder,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => builder,
      // isDismissible: false,
      enableDrag: false,
    );
  }

  void showModalTopSheet(
    BuildContext context,
    String message,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Item 1'),
                      onTap: () => Navigator.of(context).pop('item1'),
                    ),
                    ListTile(
                      title: const Text('Item 2'),
                      onTap: () => Navigator.of(context).pop('item2'),
                    ),
                    ListTile(
                      title: const Text('Item 3'),
                      onTap: () => Navigator.of(context).pop('item3'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }
}
