import 'package:quira/core/parsers/json_parser.dart';
import 'package:quira/layers/domain/entities/catalog/alternative_entity.dart';

class _Keys {
  static const id = 'id';
  static const title = 'title';
}

class AlternativeDto {
  final int id;
  final String title;

  AlternativeDto({required this.id, required this.title});

  factory AlternativeDto.fromJson(Map<String, dynamic> json) {
    final id = JsonParser.requiredInt(json[_Keys.id], key: _Keys.id);
    final title = JsonParser.requiredString(
      json[_Keys.title],
      key: _Keys.title,
    );

    return AlternativeDto(id: id, title: title);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{_Keys.id: id, _Keys.title: title};
  }

  AlternativeEntity toEntity() {
    return AlternativeEntity(id: id, text: title);
  }
}
