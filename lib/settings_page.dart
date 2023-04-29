import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/app_theme.dart';
import 'package:tictactoe/payments_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const SettingsPage());

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.getTheme(context);
    final settingsList = [
      TextButton(
        onPressed: () => context.read<PaymentsProvider>().restorePurchases(),
        child: Row(
          children: [
            Icon(
              Icons.monetization_on_outlined,
              size: appTheme.iconSize,
            ),
            const SizedBox(width: 8),
            Text(
              'Restore purchases',
              style: TextStyle(fontSize: appTheme.textSize),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemBuilder: (_, index) => settingsList[index],
        separatorBuilder: (_, __) => const Divider(),
        itemCount: settingsList.length,
      ),
    );
  }
}
