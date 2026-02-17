import 'package:quira/core/parsers/json_parser.dart';
import 'package:quira/layers/data/dtos/quiz_attempt_dto.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';

class _Keys {
  static const attempts = 'attempts';
}

class QuizHistoryDto {
  final List<QuizAttemptDto> attempts;

  QuizHistoryDto({required List<QuizAttemptDto> attempts})
    : attempts = List.unmodifiable(attempts);

  factory QuizHistoryDto.empty() {
    return QuizHistoryDto(attempts: const []);
  }

  factory QuizHistoryDto.fromJson(Map<String, dynamic> json) {
    final attempts = <QuizAttemptDto>[];
    final rawAttempts = json[_Keys.attempts];
    if (rawAttempts is List) {
      for (final attemptJson in rawAttempts) {
        try {
          attempts.add(
            QuizAttemptDto.fromJson(
              JsonParser.mapValue(attemptJson, key: _Keys.attempts),
            ),
          );
        } catch (_) {}
      }
    }

    return QuizHistoryDto(attempts: attempts);
  }

  factory QuizHistoryDto.fromEntity(List<QuizAttemptEntity> entities) {
    return QuizHistoryDto(
      attempts: entities.map((entity) {
        return QuizAttemptDto.fromEntity(entity);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _Keys.attempts: attempts.map((attempt) {
        return attempt.toJson();
      }).toList(),
    };
  }

  List<QuizAttemptEntity> toEntity() {
    final entities = <QuizAttemptEntity>[];

    for (final attempt in attempts) {
      try {
        entities.add(attempt.toEntity());
      } catch (_) {}
    }

    return entities;
  }
}
