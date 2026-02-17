import 'package:quira/layers/domain/entities/catalog/question_entity.dart';

class QuizEntity {
  final int id;
  final String title;
  final List<QuestionEntity> questions;

  QuizEntity({
    required this.id,
    required this.title,
    required List<QuestionEntity> questions,
  }) : questions = List.unmodifiable(questions) {
    if (id <= 0) {
      throw ArgumentError.value(id, 'id', 'Quiz id must be positive.');
    }

    if (title.trim().isEmpty) {
      throw ArgumentError.value(title, 'title', 'Quiz title cannot be empty.');
    }

    final questionIds = questions.map((question) {
      return question.id;
    }).toSet();
    if (questionIds.length != questions.length) {
      throw ArgumentError(
        'Quiz questions cannot contain duplicated ids.',
        'questions',
      );
    }
  }
}
