import 'package:quira/core/parsers/json_parser.dart';
import 'package:quira/layers/data/dtos/quiz_answer_dto.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';

class _Keys {
  static const quizId = 'quizId';
  static const answers = 'answers';
}

class QuizAttemptDto {
  final int quizId;
  final List<QuizAnswerDto> answers;

  QuizAttemptDto({required this.quizId, required this.answers});

  factory QuizAttemptDto.fromJson(Map<String, dynamic> json) {
    final quizId = JsonParser.requiredInt(
      json[_Keys.quizId],
      key: _Keys.quizId,
    );
    final answers = <QuizAnswerDto>[];
    final rawAnswers = json[_Keys.answers];
    if (rawAnswers is List) {
      for (final answerJson in rawAnswers) {
        try {
          answers.add(
            QuizAnswerDto.fromJson(
              JsonParser.mapValue(answerJson, key: _Keys.answers),
            ),
          );
        } catch (_) {}
      }
    }

    return QuizAttemptDto(quizId: quizId, answers: answers);
  }

  factory QuizAttemptDto.fromEntity(QuizAttemptEntity entity) {
    return QuizAttemptDto(
      quizId: entity.quizId,
      answers: entity.answers.map((answer) {
        return QuizAnswerDto.fromEntity(answer);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _Keys.quizId: quizId,
      _Keys.answers: answers.map((answer) {
        return answer.toJson();
      }).toList(),
    };
  }

  QuizAttemptEntity toEntity() {
    return QuizAttemptEntity(
      quizId: quizId,
      answers: answers.map((answer) {
        return answer.toEntity();
      }).toList(),
    );
  }
}
