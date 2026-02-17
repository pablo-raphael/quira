import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';
import 'package:quira/layers/domain/repositories/quiz_repository.dart';

class SaveAttemptUseCase {
  final QuizRepository _quizRepository;

  SaveAttemptUseCase(this._quizRepository);

  Future<void> call(QuizAttemptEntity attempt) async {
    try {
      await _quizRepository.saveAttempt(attempt);
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
