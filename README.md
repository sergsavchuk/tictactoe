# Tic Tac Toe

Tic Tac Toe for iOS & Android

## Configuration
### AdMob
#### .env
Create `.env` file in the project root with:
```shell
ANDROID_BANNER_AD_UNIT_ID=your-android-banner-ad-unit-id
IOS_BANNER_AD_UNIT_ID=your-ios-banner-ad-unit-id
```
And run `flutter pub run build_runner build` to generate `lib/env/env.g.dart`.

#### iOS
Create `ios/Flutter/Local.xcconfig` to provide the AdMob App ID for iOS:
```shell
ADMOB_APP_ID=your-ios-admob-app-id
```

#### Android
Add following line to `android/local.properties` to provide the AdMob App ID for Android:
```shell
admobAppId=your-android-admob-app-id
```
