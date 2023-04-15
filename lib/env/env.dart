import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'ANDROID_BANNER_AD_UNIT_ID')
  static final androidBannerAdUnitId = _Env.androidBannerAdUnitId;

  @EnviedField(varName: 'IOS_BANNER_AD_UNIT_ID')
  static final iosBannerAdUnitId = _Env.iosBannerAdUnitId;
}
