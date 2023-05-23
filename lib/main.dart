import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/analytics_provider.dart';
import 'package:tictactoe/app_theme.dart';
import 'package:tictactoe/firebase_options.dart';
import 'package:tictactoe/game_page.dart';
import 'package:tictactoe/payments_provider.dart';
import 'package:tictactoe/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // hide system UI overlays
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // TODO(sergsavchuk): process initialization errors
  await MobileAds.instance.initialize();

  final paymentsProvider = PaymentsProvider();
  await paymentsProvider.init();

  final analyticsProvider = AnalyticsProvider(FirebaseAnalytics.instance);

  runApp(
    MyApp(
      paymentsProvider: paymentsProvider,
      analyticsProvider: analyticsProvider,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.paymentsProvider,
    required this.analyticsProvider,
    super.key,
  });

  final PaymentsProvider paymentsProvider;
  final AnalyticsProvider analyticsProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: paymentsProvider),
        Provider.value(value: analyticsProvider),
      ],
      child: MaterialApp(
        title: 'Tic Tac Toe',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const MenuPage(),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const MenuPage());

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.getTheme(context);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: IconButton(
              iconSize: appTheme.largeIconSize,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.play_circle_fill),
              onPressed: () => Navigator.of(context).push(GamePage.route()),
              style: Theme.of(context).iconButtonTheme.style,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.of(context).push(SettingsPage.route()),
              icon: Icon(
                Icons.settings,
                size: appTheme.iconSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
