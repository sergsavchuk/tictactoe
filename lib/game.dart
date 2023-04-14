import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/match.dart';

enum CellState { empty, cross, circle }

typedef GameRestartFunction = void Function();
typedef GameOverCallback = void Function(
  String result,
  GameRestartFunction restartFunction,
);

class Game with ChangeNotifier {
  Game({
    required this.fieldSize,
    required this.playerHasFirstTurn,
    required GameOverCallback gameOverCallback,
  }) : _gameOverCallback = gameOverCallback {
    _fieldState = List.generate(
      fieldSize * fieldSize,
      (_) => CellState.empty,
    );

    if (!playerHasFirstTurn) {
      _opponentTurn();
    }
  }

  final int fieldSize;
  final bool playerHasFirstTurn;
  final GameOverCallback _gameOverCallback;

  // TODO(sergsavchuk): replace by two-dimensional list
  late final List<CellState> _fieldState;
  Match? _match;
  bool _draw = false;

  void playerTap(int cellIndex) {
    if (!_gameOver &&
        _fieldState[cellIndex] == CellState.empty &&
        _isPlayerTurn()) {
      _fieldState[cellIndex] =
          playerHasFirstTurn ? CellState.cross : CellState.circle;

      _checkGameOver();
      notifyListeners();

      if (!_gameOver) {
        _opponentTurn();
      }
    }
  }

  CellState cellState(int cellIndex) => _fieldState[cellIndex];

  bool isFirstColumn(int cellIndex) => cellIndex % fieldSize == 0;

  bool isFirstRow(int cellIndex) => cellIndex / fieldSize < 1;

  MatchType? isPartOfMatch(int cellIndex) {
    return _match != null && _match!.cellIndices.contains(cellIndex)
        ? _match!.type
        : null;
  }

  void _restart() {
    _match = null;
    _draw = false;
    _fieldState.fillRange(0, fieldSize * fieldSize, CellState.empty);
    notifyListeners();
  }

  Future<void> _opponentTurn() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final freeCellsCount =
        _fieldState.where((element) => element == CellState.empty).length;
    if (freeCellsCount == 0) {
      return;
    }

    var randomFreeCellIndex = Random().nextInt(freeCellsCount);
    for (var i = 0; i < _fieldState.length; i++) {
      if (_fieldState[i] == CellState.empty) {
        if (randomFreeCellIndex-- == 0) {
          _fieldState[i] =
              playerHasFirstTurn ? CellState.circle : CellState.cross;

          _checkGameOver();

          notifyListeners();
        }
      }
    }
  }

  bool _isPlayerTurn() {
    final crossesCount =
        _fieldState.where((element) => element == CellState.cross).length;
    final circlesCount =
        _fieldState.where((element) => element == CellState.circle).length;
    if (playerHasFirstTurn) {
      return crossesCount == circlesCount;
    }

    return circlesCount < crossesCount;
  }

  bool get _gameOver => _draw || _match != null;

  void _checkGameOver() {
    if (_match == null) {
      _match = Match.findMatch(_fieldState, fieldSize);

      final match = _match;
      if (match == null) {
        _draw =
            _fieldState.where((element) => element == CellState.empty).isEmpty;

        if (_draw) {
          _gameOverCallback('Draw', _restart);
        }

        return;
      }

      if ((_fieldState[match.cellIndices[0]] == CellState.cross &&
              playerHasFirstTurn) ||
          (_fieldState[match.cellIndices[0]] == CellState.circle &&
              !playerHasFirstTurn)) {
        _gameOverCallback('Win', _restart);
      } else {
        _gameOverCallback('Defeat', _restart);
      }
    }
  }
}
