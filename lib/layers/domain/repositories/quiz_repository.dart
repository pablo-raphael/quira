import 'package:quira/core/language/app_language.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';

abstract class QuizRepository {
  Future<List<QuizEntity>> getAllQuizzes(AppLanguage language);

  Future<List<QuizAttemptEntity>> getAllAttempts();

  Future<QuizAttemptEntity?> getAttemptByQuizId(int quizId);

  Future<void> saveAttempt(QuizAttemptEntity attempt);

  Future<void> deleteAttemptByQuizId(int quizId);
}
