import 'package:flutter/foundation.dart';

enum RunMode {
  debug,
  release,
  profile;

  static RunMode get current {
    if (kDebugMode) {
      return RunMode.debug;
    } else if (kReleaseMode) {
      return RunMode.release;
    } else if (kProfileMode) {
      return RunMode.profile;
    } else {
      throw UnimplementedError();
    }
  }
}
