import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/game_page.dart';
import 'package:tictactoe/payments_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hide system UI overlays
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // TODO(sergsavchuk): process initialization errors
  await MobileAds.instance.initialize();

  final paymentsProvider = PaymentsProvider();
  await paymentsProvider.init();

  runApp(MyApp(paymentsProvider: paymentsProvider));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.paymentsProvider, super.key});

  final PaymentsProvider paymentsProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: paymentsProvider),
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
    return Scaffold(
      body: Center(
        child: IconButton(
          iconSize: 150,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.play_circle_fill,
          ),
          onPressed: () => Navigator.of(context).push(GamePage.route()),
          style: Theme.of(context).iconButtonTheme.style,
        ),
      ),
    );
  }
}
