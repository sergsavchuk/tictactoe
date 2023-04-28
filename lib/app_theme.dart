import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AppTheme {
  AppTheme(this.orientation);

  static const tabletSmallWidth = 600;

  final Orientation orientation;

  double get iconSize;

  AdSize get adBannerSize;

  double get textSize;

  static AppTheme getTheme(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.shortestSide >= tabletSmallWidth) {
      return _TabletAppTheme(MediaQuery.of(context).orientation);
    }

    return _PhoneAppTheme(MediaQuery.of(context).orientation);
  }
}

class _PhoneAppTheme extends AppTheme {
  _PhoneAppTheme(super.orientation);

  @override
  double get iconSize => 50;

  @override
  AdSize get adBannerSize => AdSize.banner;

  @override
  double get textSize => 30;
}

class _TabletAppTheme extends AppTheme {
  _TabletAppTheme(super.orientation);

  @override
  double get iconSize => 100;

  @override
  AdSize get adBannerSize => AdSize.largeBanner;

  @override
  double get textSize => 45;
}
