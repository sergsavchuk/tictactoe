import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/ad_banner_widget.dart';
import 'package:tictactoe/game.dart';
import 'package:tictactoe/main.dart';
import 'package:tictactoe/match.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const GamePage());

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    gameOverCallback: (result, restart) => showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              result,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context)
                                      .push(MenuPage.route()),
                                  iconSize: 50,
                                  icon: const Icon(Icons.home),
                                ),
                                IconButton(
                                  onPressed: () {
                                    restart();
                                    Navigator.of(context).pop();
                                  },
                                  iconSize: 50,
                                  icon: const Icon(Icons.refresh),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: const _GameField(),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AdBannerWidget(),
          )
        ],
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
              builder: (_, game, __) => _getCellContent(game, index),
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
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(iconData, size: 50),
          if (matchTypeForCell != null)
            LayoutBuilder(
              builder: (_, constrains) => CustomPaint(
                size: constrains.biggest,
                painter: _MatchPainter(matchTypeForCell),
              ),
            )
        ],
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
