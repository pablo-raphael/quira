import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/core/language/app_language.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';
import 'package:quira/layers/domain/repositories/quiz_repository.dart';

class GetAllQuizzesUseCase {
  final QuizRepository _quizRepository;

  GetAllQuizzesUseCase(this._quizRepository);

  Future<List<QuizEntity>> call(AppLanguage language) async {
    try {
      return await _quizRepository.getAllQuizzes(language);
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
