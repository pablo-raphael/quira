import 'package:quira/core/parsers/json_parser.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_answer_entity.dart';

class _Keys {
  static const questionId = 'questionId';
  static const selectedAlternativeId = 'selectedAlternativeId';
}

class QuizAnswerDto {
  final int questionId;
  final int selectedAlternativeId;

  QuizAnswerDto({
    required this.questionId,
    required this.selectedAlternativeId,
  });

  factory QuizAnswerDto.fromJson(Map<String, dynamic> json) {
    final questionId = JsonParser.requiredInt(
      json[_Keys.questionId],
      key: _Keys.questionId,
    );
    final selectedAlternativeId = JsonParser.requiredInt(
      json[_Keys.selectedAlternativeId],
      key: _Keys.selectedAlternativeId,
    );

    return QuizAnswerDto(
      questionId: questionId,
      selectedAlternativeId: selectedAlternativeId,
    );
  }

  factory QuizAnswerDto.fromEntity(QuizAnswerEntity entity) {
    return QuizAnswerDto(
      questionId: entity.questionId,
      selectedAlternativeId: entity.selectedAlternativeId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _Keys.questionId: questionId,
      _Keys.selectedAlternativeId: selectedAlternativeId,
    };
  }

  QuizAnswerEntity toEntity() {
    return QuizAnswerEntity(
      questionId: questionId,
      selectedAlternativeId: selectedAlternativeId,
    );
  }
}
