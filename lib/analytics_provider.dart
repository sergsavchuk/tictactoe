import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:tictactoe/enums/cell_state.dart';
import 'package:tictactoe/enums/game_result.dart';

class AnalyticsProvider {
  AnalyticsProvider(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logMatchResult({
    required GameResult result,
    required CellState figure,
    String opponentType = 'default-bot-v1',
  }) =>
      _analytics.logEvent(
        name: 'match_result',
        parameters: {
          'result': result.name,
          'figure': figure.name,
          'opponentType': opponentType,
        },
      );
}
