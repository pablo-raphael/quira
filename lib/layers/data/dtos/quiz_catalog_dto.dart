import 'package:quira/core/parsers/json_parser.dart';
import 'package:quira/layers/data/dtos/quiz_dto.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';

class _Keys {
  static const version = 'version';
  static const quizzes = 'quizzes';
  static const defaultVersion = 1;
}

class QuizCatalogDto {
  final int version;
  final List<QuizDto> quizzes;

  QuizCatalogDto({required this.version, required this.quizzes});

  factory QuizCatalogDto.fromJson(Map<String, dynamic> json) {
    var version = _Keys.defaultVersion;
    try {
      version = JsonParser.requiredInt(json[_Keys.version], key: _Keys.version);
    } catch (_) {}

    final quizzes = <QuizDto>[];
    final rawQuizzes = json[_Keys.quizzes];
    if (rawQuizzes is List) {
      for (final quizJson in rawQuizzes) {
        try {
          quizzes.add(
            QuizDto.fromJson(JsonParser.mapValue(quizJson, key: _Keys.quizzes)),
          );
        } catch (_) {}
      }
    }

    return QuizCatalogDto(version: version, quizzes: quizzes);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _Keys.version: version,
      _Keys.quizzes: quizzes.map((quiz) {
        return quiz.toJson();
      }).toList(),
    };
  }

  List<QuizEntity> toEntity() {
    final entities = <QuizEntity>[];

    for (final quiz in quizzes) {
      try {
        entities.add(quiz.toEntity());
      } catch (_) {}
    }

    return entities;
  }
}
