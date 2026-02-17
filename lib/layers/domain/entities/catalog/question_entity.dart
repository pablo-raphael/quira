import 'package:quira/layers/domain/entities/catalog/alternative_entity.dart';

class QuestionEntity {
  final int id;
  final String prompt;
  final int correctAlternativeId;
  final List<AlternativeEntity> alternatives;

  QuestionEntity({
    required this.id,
    required this.prompt,
    required this.correctAlternativeId,
    required List<AlternativeEntity> alternatives,
  }) : alternatives = List.unmodifiable(alternatives) {
    if (id <= 0) {
      throw ArgumentError.value(id, 'id', 'Question id must be positive.');
    }

    if (prompt.trim().isEmpty) {
      throw ArgumentError.value(
        prompt,
        'prompt',
        'Question prompt cannot be empty.',
      );
    }

    if (alternatives.isEmpty) {
      throw ArgumentError(
        'Question alternatives cannot be empty.',
        'alternatives',
      );
    }

    final alternativesIds = alternatives.map((alternative) {
      return alternative.id;
    }).toSet();
    if (alternativesIds.length != alternatives.length) {
      throw ArgumentError(
        'Question alternatives cannot contain duplicated ids.',
        'alternatives',
      );
    }

    final hasCorrectAlternative = alternatives.any((alternative) {
      return alternative.id == correctAlternativeId;
    });
    if (!hasCorrectAlternative) {
      throw ArgumentError.value(
        correctAlternativeId,
        'correctAlternativeId',
        'Must reference an existing alternative id.',
      );
    }
  }
}
