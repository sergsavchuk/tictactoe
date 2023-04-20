import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tictactoe/game_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(sergsavchuk): process initialization errors
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MenuPage(),
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
