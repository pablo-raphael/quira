class QuizAnswerEntity {
  final int questionId;
  final int selectedAlternativeId;

  QuizAnswerEntity({
    required this.questionId,
    required this.selectedAlternativeId,
  }) {
    if (questionId <= 0) {
      throw ArgumentError.value(
        questionId,
        'questionId',
        'Question id must be positive.',
      );
    }

    if (selectedAlternativeId <= 0) {
      throw ArgumentError.value(
        selectedAlternativeId,
        'selectedAlternativeId',
        'Selected alternative id must be positive.',
      );
    }
  }
}
