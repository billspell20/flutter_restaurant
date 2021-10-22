import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1590976018869330/9422676485';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1590976018869330/5298409278';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
