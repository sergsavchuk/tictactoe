import 'package:tictactoe/game.dart';

enum MatchType { row, column, leftDiagonal, rightDiagonal }

class Match {
  Match(this.type, this.cellIndices);

  final MatchType type;
  final List<int> cellIndices;

  static Match? findMatch(List<CellState> fieldState, int fieldSize) {
    for (var i = 0; i < fieldSize; i++) {
      if (_checkRowMatch(fieldState, fieldSize, i)) {
        return Match(
          MatchType.row,
          List.generate(fieldSize, (index) => i * fieldSize + index),
        );
      } else if (_checkColumnMatch(fieldState, fieldSize, i)) {
        return Match(
          MatchType.column,
          List.generate(fieldSize, (index) => i + fieldSize * index),
        );
      }
    }

    if (_checkLeftDiagonal(fieldState, fieldSize)) {
      return Match(
        MatchType.leftDiagonal,
        List.generate(fieldSize, (index) => index * fieldSize + index),
      );
    }
    if (_checkRightDiagonal(fieldState, fieldSize)) {
      return Match(
        MatchType.rightDiagonal,
        List.generate(
          fieldSize,
          (index) => index * fieldSize + fieldSize - 1 - index,
        ),
      );
    }

    return null;
  }

  static bool _checkRowMatch(
    List<CellState> fieldState,
    int fieldSize,
    int index,
  ) {
    final firstCellIndex = index * fieldSize;
    final firstCellState = fieldState[firstCellIndex];
    for (var i = 1; i < fieldSize; i++) {
      if (fieldState[firstCellIndex + i] != firstCellState) {
        return false;
      }
    }

    return firstCellState != CellState.empty;
  }

  static bool _checkColumnMatch(
    List<CellState> fieldState,
    int fieldSize,
    int index,
  ) {
    final firstCellState = fieldState[index];
    for (var i = 1; i < fieldSize; i++) {
      if (fieldState[i * fieldSize + index] != firstCellState) {
        return false;
      }
    }

    return firstCellState != CellState.empty;
  }

  static bool _checkLeftDiagonal(List<CellState> fieldState, int fieldSize) {
    final firstCellState = fieldState[0];
    for (var i = 1; i < fieldSize; i++) {
      if (fieldState[i * fieldSize + i] != firstCellState) {
        return false;
      }
    }

    return firstCellState != CellState.empty;
  }

  static bool _checkRightDiagonal(List<CellState> fieldState, int fieldSize) {
    final firstCellState = fieldState[fieldSize - 1];
    for (var i = 1; i < fieldSize; i++) {
      if (fieldState[i * fieldSize + fieldSize - 1 - i] != firstCellState) {
        return false;
      }
    }

    return firstCellState != CellState.empty;
  }
}
