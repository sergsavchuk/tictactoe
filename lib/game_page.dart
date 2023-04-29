import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/ad_banner_widget.dart';
import 'package:tictactoe/app_theme.dart';
import 'package:tictactoe/game.dart';
import 'package:tictactoe/main.dart';
import 'package:tictactoe/match.dart';
import 'package:tictactoe/payments_provider.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const GamePage());

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.getTheme(context);
    return Provider<AppTheme>.value(
      value: appTheme,
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: ChangeNotifierProvider(
                    create: (context) => Game(
                      fieldSize: 3,
                      gameOverCallback: (result, restart) =>
                          _gameOverCallback(context, appTheme, result, restart),
                    ),
                    child: const _GameField(),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: appTheme.orientation == Orientation.portrait ? 0 : null,
              right: 0,
              top: appTheme.orientation == Orientation.landscape ? 0 : null,
              child: Consumer<PaymentsProvider>(
                builder: (_, paymentsProvider, __) => Visibility(
                  visible: !paymentsProvider.noAds,
                  child: RotatedBox(
                    quarterTurns:
                        appTheme.orientation == Orientation.landscape ? 1 : 0,
                    child: AdBannerWidget(
                      bannerSize: appTheme.adBannerSize,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: appTheme.orientation == Orientation.portrait
                  ? 0
                  : appTheme.adBannerSize.height.toDouble(),
              bottom: appTheme.orientation == Orientation.portrait
                  ? appTheme.adBannerSize.height.toDouble()
                  : 0,
              child: Consumer<PaymentsProvider>(
                builder: (_, paymentsProvider, __) => Visibility(
                  visible:
                      !paymentsProvider.noAds && paymentsProvider.available,
                  child: const _NoAdsButton(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _gameOverCallback(
    BuildContext context,
    AppTheme appTheme,
    String result,
    GameRestartFunction restart,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result,
                style:
                    Theme.of(context).primaryTextTheme.headlineLarge?.copyWith(
                          color: Colors.black,
                          fontSize: appTheme.largeTextSize,
                        ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).push(MenuPage.route()),
                    iconSize: appTheme.iconSize,
                    icon: const Icon(Icons.home),
                  ),
                  IconButton(
                    onPressed: () {
                      restart();
                      Navigator.of(context).pop();
                    },
                    iconSize: appTheme.iconSize,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameField extends StatelessWidget {
  const _GameField();

  @override
  Widget build(BuildContext context) {
    final initialGame = Provider.of<Game>(context, listen: false);
    return GridView.count(
      crossAxisCount: initialGame.fieldSize,
      padding: EdgeInsets.zero,
      children: List.generate(
        initialGame.fieldSize * initialGame.fieldSize,
        (index) => GestureDetector(
          onTap: () => initialGame.playerTap(index),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: initialGame.isFirstColumn(index)
                    ? BorderSide.none
                    : const BorderSide(width: 2),
                top: initialGame.isFirstRow(index)
                    ? BorderSide.none
                    : const BorderSide(width: 2),
              ),
            ),
            child: Consumer<Game>(
              builder: (context, game, __) => _getCellContent(game, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCellContent(Game game, int cellIndex) {
    final matchTypeForCell = game.isPartOfMatch(cellIndex);
    final cellState = game.cellState(cellIndex);

    IconData? iconData;
    if (cellState == CellState.circle) {
      iconData = Icons.circle_outlined;
    } else if (cellState == CellState.cross) {
      iconData = Icons.close;
    }

    if (cellState == CellState.empty) {
      return const SizedBox.shrink();
    } else {
      return LayoutBuilder(
        builder: (_, constraints) => Stack(
          alignment: Alignment.center,
          children: [
            Icon(iconData, size: constraints.maxWidth * .55),
            if (matchTypeForCell != null)
              CustomPaint(
                size: constraints.biggest,
                painter: _MatchPainter(matchTypeForCell),
              )
          ],
        ),
      );
    }
  }
}

class _MatchPainter extends CustomPainter {
  _MatchPainter(this.matchType);

  final MatchType matchType;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;

    switch (matchType) {
      case MatchType.row:
        canvas.drawLine(
          size.centerLeft(Offset.zero),
          size.centerRight(Offset.zero),
          paint,
        );
        break;
      case MatchType.column:
        canvas.drawLine(
          size.topCenter(Offset.zero),
          size.bottomCenter(Offset.zero),
          paint,
        );
        break;
      case MatchType.leftDiagonal:
        canvas.drawLine(Offset.zero, size.bottomRight(Offset.zero), paint);
        break;
      case MatchType.rightDiagonal:
        canvas.drawLine(
          size.topRight(Offset.zero),
          size.bottomLeft(Offset.zero),
          paint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _NoAdsButton extends StatelessWidget {
  const _NoAdsButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'Ads',
          style: TextStyle(
            fontSize: context.read<AppTheme>().iconSize / 2.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Provider.of<PaymentsProvider>(context, listen: false)
              .purchaseNoAds(),
          icon: Icon(
            Icons.not_interested,
            color: Colors.red,
            size: context.read<AppTheme>().iconSize,
          ),
        ),
      ],
    );
  }
}
