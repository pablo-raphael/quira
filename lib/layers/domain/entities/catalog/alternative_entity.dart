class AlternativeEntity {
  final int id;
  final String text;

  AlternativeEntity({required this.id, required this.text}) {
    if (id <= 0) {
      throw ArgumentError.value(id, 'id', 'Alternative id must be positive.');
    }

    if (text.trim().isEmpty) {
      throw ArgumentError.value(
        text,
        'text',
        'Alternative text cannot be empty.',
      );
    }
  }
}
