import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';
import 'package:quira/layers/domain/repositories/quiz_repository.dart';

class GetAllAttemptsUseCase {
  final QuizRepository _quizRepository;

  GetAllAttemptsUseCase(this._quizRepository);

  Future<List<QuizAttemptEntity>> call() async {
    try {
      return await _quizRepository.getAllAttempts();
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
