import 'package:flutter/material.dart';

enum Flavor {
  dev,
  prod,
}

class Config {
  static late Flavor appFlavor;

  static Widget get flavorBanner {
    if (appFlavor == Flavor.dev) {
      return const Banner(
        message: 'dev',
        location: BannerLocation.topEnd,
      );
    }

    return const SizedBox.shrink();
  }
}
