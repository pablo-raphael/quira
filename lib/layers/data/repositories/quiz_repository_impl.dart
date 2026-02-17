import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/core/language/app_language.dart';
import 'package:quira/layers/data/datasources/quiz_catalog_data_source.dart';
import 'package:quira/layers/data/datasources/quiz_history_data_source.dart';
import 'package:quira/layers/data/dtos/quiz_history_dto.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';
import 'package:quira/layers/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizHistoryDataSource _quizHistoryDataSource;
  final QuizCatalogDataSource _quizCatalogDataSource;

  QuizRepositoryImpl({
    required QuizHistoryDataSource quizHistoryDataSource,
    required QuizCatalogDataSource quizCatalogDataSource,
  }) : _quizHistoryDataSource = quizHistoryDataSource,
       _quizCatalogDataSource = quizCatalogDataSource;

  @override
  Future<List<QuizEntity>> getAllQuizzes(AppLanguage language) async {
    try {
      final quizzesCatalog = await _quizCatalogDataSource.getCatalog(language);
      return quizzesCatalog.toEntity();
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.unknown,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<QuizAttemptEntity>> getAllAttempts() async {
    try {
      final historyDto = await _quizHistoryDataSource.getHistory();
      return historyDto.toEntity();
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.unknown,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }

  @override
  Future<QuizAttemptEntity?> getAttemptByQuizId(int quizId) async {
    try {
      final attempts = await getAllAttempts();

      for (final attempt in attempts) {
        if (attempt.quizId == quizId) {
          return attempt;
        }
      }

      return null;
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.unknown,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> saveAttempt(QuizAttemptEntity attempt) async {
    try {
      final attempts = await getAllAttempts();

      final updatedAttempts = attempts.where((item) {
        return item.quizId != attempt.quizId;
      }).toList();
      updatedAttempts.add(attempt);

      final updatedHistoryDto = QuizHistoryDto.fromEntity(updatedAttempts);
      await _quizHistoryDataSource.setHistory(updatedHistoryDto);
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.unknown,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteAttemptByQuizId(int quizId) async {
    try {
      final attempts = await getAllAttempts();

      final updatedAttempts = attempts.where((attempt) {
        return attempt.quizId != quizId;
      }).toList();

      final updatedHistoryDto = QuizHistoryDto.fromEntity(updatedAttempts);
      await _quizHistoryDataSource.setHistory(updatedHistoryDto);
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.unknown,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }
}
