import 'package:flutter/material.dart' show AssetImage;

class Assets {
  const Assets._();

  static const _icPath = 'assets/icons';
  static const _imgPath = 'assets/images';
  static const _videoPath = 'assets/videos';

  static AssetImage logo = const AssetImage('$_icPath/logo.png');
  static AssetImage dooboolab = const AssetImage('$_imgPath/dooboolab.png');
  static AssetImage dooboolabLogo = const AssetImage('$_imgPath/logo.png');
  static const sampleVideo = '$_videoPath/sample.mp4';
}

class Svgs {
  const Svgs._();

  // static const _svgPath = 'assets/svgs';
}
