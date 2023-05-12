import 'package:veple/utils/tools.dart';

class Config {
  factory Config() {
    return _singleton;
  }

  Config._internal();
  static final Config _singleton = Config._internal();

  String get nativeAppKey => env('NATIVE_APP_KEY');
  String get javascriptAppKey => env('JAVASCRIPT_APP_KEY');
}
