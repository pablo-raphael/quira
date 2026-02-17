import 'package:quira/layers/domain/entities/attempt/quiz_answer_entity.dart';

class QuizAttemptEntity {
  final int quizId;
  final List<QuizAnswerEntity> answers;

  QuizAttemptEntity({
    required this.quizId,
    required List<QuizAnswerEntity> answers,
  }) : answers = List.unmodifiable(answers) {
    if (quizId <= 0) {
      throw ArgumentError.value(quizId, 'quizId', 'Quiz id must be positive.');
    }

    if (answers.isEmpty) {
      throw ArgumentError('Quiz attempt answers cannot be empty.', 'answers');
    }

    final answeredQuestionIds = answers.map((answer) {
      return answer.questionId;
    }).toSet();
    if (answeredQuestionIds.length != answers.length) {
      throw ArgumentError(
        'Quiz attempt cannot contain duplicated answers for the same question.',
        'answers',
      );
    }
  }
}
