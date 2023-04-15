import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tictactoe/env/env.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  // https://developers.google.com/admob/flutter/banner#always_test_with_test_ads
  final debugAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  final releaseAdUnitId =
      Platform.isAndroid ? Env.androidBannerAdUnitId : Env.iosBannerAdUnitId;

  final bannerSize = AdSize.banner;
  BannerAd? banner;

  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: kDebugMode ? debugAdUnitId : releaseAdUnitId,
      request: const AdRequest(),
      size: bannerSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            banner = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          // TODO(sergsavchuk): handle err
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: bannerSize.width.toDouble(),
      height: bannerSize.height.toDouble(),
      child: banner != null ? AdWidget(ad: banner!) : null,
    );
  }

  @override
  void dispose() {
    super.dispose();

    banner?.dispose();
  }
}
