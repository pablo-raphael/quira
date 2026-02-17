import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';

class JsonParser {
  JsonParser._();

  static Map<String, dynamic> requiredMap(
    Map<String, dynamic> json, {
    required String key,
  }) {
    final value = json[key];
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw const QuiraException(QuiraError.invalidExternalData);
  }

  static List<dynamic> requiredList(
    Map<String, dynamic> json, {
    required String key,
  }) {
    final value = json[key];
    if (value is List) {
      return value;
    }

    throw const QuiraException(QuiraError.invalidExternalData);
  }

  static Map<String, dynamic> mapValue(dynamic value, {required String key}) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw const QuiraException(QuiraError.invalidExternalData);
  }

  static int requiredInt(dynamic value, {required String key}) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    throw const QuiraException(QuiraError.invalidExternalData);
  }

  static String requiredString(dynamic value, {required String key}) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    throw const QuiraException(QuiraError.invalidExternalData);
  }

  static int? toIntOrNull(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
