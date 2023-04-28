# Tic Tac Toe

Tic Tac Toe for iOS & Android

[<img src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png"
      alt="Get it on Google Play"
      height="80">](https://play.google.com/store/apps/details?id=com.sergsavchuk.tictactoe&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1)
[<img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x80&amp;releaseDate=1310601600" 
      alt="Download on the App Store"
      style="border-radius: 13px;
      width: 250px;
      height: 80px;">](#)

## Features
- AdMob ads
- In-app purchases
- Provider state management
- Responsive UI

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
