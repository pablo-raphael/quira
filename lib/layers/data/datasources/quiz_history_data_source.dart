import 'dart:convert';

import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/layers/data/dtos/quiz_history_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static const history = 'history';
}

class QuizHistoryDataSource {
  Future<QuizHistoryDto> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawHistory = prefs.get(_Keys.history);
      if (rawHistory == null) {
        return QuizHistoryDto.empty();
      }

      if (rawHistory is! String) {
        await prefs.remove(_Keys.history);
        return QuizHistoryDto.empty();
      }

      if (rawHistory.trim().isEmpty) {
        return QuizHistoryDto.empty();
      }

      final decoded = json.decode(rawHistory);
      if (decoded is! Map) {
        await prefs.remove(_Keys.history);
        return QuizHistoryDto.empty();
      }

      return QuizHistoryDto.fromJson(Map<String, dynamic>.from(decoded));
    } on FormatException {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_Keys.history);
      return QuizHistoryDto.empty();
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.storageReadFailed,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }

  Future<void> setHistory(QuizHistoryDto history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wasSaved = await prefs.setString(
        _Keys.history,
        json.encode(history.toJson()),
      );
      if (!wasSaved) {
        throw const QuiraException(QuiraError.storageWriteFailed);
      }
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.storageWriteFailed,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }
}
