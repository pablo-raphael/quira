import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/layers/domain/repositories/quiz_repository.dart';

class DeleteAttemptByQuizIdUseCase {
  final QuizRepository _quizRepository;

  DeleteAttemptByQuizIdUseCase(this._quizRepository);

  Future<void> call(int quizId) async {
    try {
      await _quizRepository.deleteAttemptByQuizId(quizId);
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
