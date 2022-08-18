import 'package:flutter/material.dart';

enum Flavor {
  dev,
  prod,
}

class Config {
  static late Flavor appFlavor;

  static Widget get flavorBanner {
    switch (appFlavor) {
      case Flavor.prod:
        return Container();
      case Flavor.dev:
        return const Banner(
          message: 'dev',
          location: BannerLocation.topEnd,
        );
      default:
        return Container();
    }
  }
}
