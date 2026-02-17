import 'package:quira/core/parsers/json_parser.dart';
import 'package:quira/layers/data/dtos/question_dto.dart';
import 'package:quira/layers/domain/entities/catalog/question_entity.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';

class _Keys {
  static const id = 'id';
  static const title = 'title';
  static const questions = 'questions';
}

class QuizDto {
  final int id;
  final String title;
  final List<QuestionDto> questions;

  QuizDto({required this.id, required this.title, required this.questions});

  factory QuizDto.fromJson(Map<String, dynamic> json) {
    final id = JsonParser.requiredInt(json[_Keys.id], key: _Keys.id);
    final title = JsonParser.requiredString(
      json[_Keys.title],
      key: _Keys.title,
    );
    final questions = <QuestionDto>[];
    final rawQuestions = json[_Keys.questions];
    if (rawQuestions is List) {
      for (final questionJson in rawQuestions) {
        try {
          questions.add(
            QuestionDto.fromJson(
              JsonParser.mapValue(questionJson, key: _Keys.questions),
            ),
          );
        } catch (_) {}
      }
    }

    return QuizDto(id: id, title: title, questions: questions);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _Keys.id: id,
      _Keys.title: title,
      _Keys.questions: questions.map((question) {
        return question.toJson();
      }).toList(),
    };
  }

  QuizEntity toEntity() {
    final questionsEntities = <QuestionEntity>[];
    for (final question in questions) {
      try {
        questionsEntities.add(question.toEntity());
      } catch (_) {}
    }

    return QuizEntity(id: id, title: title, questions: questionsEntities);
  }
}
