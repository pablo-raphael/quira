import 'package:quira/core/parsers/json_parser.dart';
import 'package:quira/layers/data/dtos/alternative_dto.dart';
import 'package:quira/layers/domain/entities/catalog/alternative_entity.dart';
import 'package:quira/layers/domain/entities/catalog/question_entity.dart';

class _Keys {
  static const id = 'id';
  static const title = 'title';
  static const prompt = 'prompt';
  static const correctAnswerId = 'correctAnswerId';
  static const alternatives = 'alternatives';
}

class _Defaults {
  static const emptyTitle = '';
}

class QuestionDto {
  final int id;
  final String title;
  final String prompt;
  final int correctAnswerId;
  final List<AlternativeDto> alternatives;

  QuestionDto({
    required this.id,
    required this.title,
    required this.prompt,
    required this.correctAnswerId,
    required this.alternatives,
  });

  factory QuestionDto.fromJson(Map<String, dynamic> json) {
    final id = JsonParser.requiredInt(json[_Keys.id], key: _Keys.id);
    final prompt = JsonParser.requiredString(
      json[_Keys.prompt],
      key: _Keys.prompt,
    );
    final correctAnswerId = JsonParser.requiredInt(
      json[_Keys.correctAnswerId],
      key: _Keys.correctAnswerId,
    );
    var title = _Defaults.emptyTitle;
    try {
      title = JsonParser.requiredString(json[_Keys.title], key: _Keys.title);
    } catch (_) {}

    final alternatives = <AlternativeDto>[];
    final rawAlternatives = json[_Keys.alternatives];
    if (rawAlternatives is List) {
      for (final alternativeJson in rawAlternatives) {
        try {
          alternatives.add(
            AlternativeDto.fromJson(
              JsonParser.mapValue(alternativeJson, key: _Keys.alternatives),
            ),
          );
        } catch (_) {}
      }
    }

    return QuestionDto(
      id: id,
      title: title,
      prompt: prompt,
      correctAnswerId: correctAnswerId,
      alternatives: alternatives,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _Keys.id: id,
      _Keys.title: title,
      _Keys.prompt: prompt,
      _Keys.correctAnswerId: correctAnswerId,
      _Keys.alternatives: alternatives.map((alternative) {
        return alternative.toJson();
      }).toList(),
    };
  }

  QuestionEntity toEntity() {
    final alternativesEntities = <AlternativeEntity>[];
    for (final alternative in alternatives) {
      try {
        alternativesEntities.add(alternative.toEntity());
      } catch (_) {}
    }

    return QuestionEntity(
      id: id,
      prompt: prompt,
      correctAlternativeId: correctAnswerId,
      alternatives: alternativesEntities,
    );
  }
}
