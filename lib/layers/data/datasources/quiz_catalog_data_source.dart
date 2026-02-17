import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/core/language/app_language.dart';
import 'package:quira/layers/data/dtos/quiz_catalog_dto.dart';

class _Keys {
  static const defaultLanguage = AppLanguage.en;
  static const catalogEnAssetPath = 'lib/mocks/quizzes_en.json';
  static const catalogPtAssetPath = 'lib/mocks/quizzes_pt.json';
}

class QuizCatalogDataSource {
  Future<QuizCatalogDto> getCatalog(AppLanguage language) async {
    try {
      return await _loadCatalogByLanguage(language);
    } on QuiraException {
      if (language == _Keys.defaultLanguage) {
        rethrow;
      }
      return await _loadCatalogByLanguage(_Keys.defaultLanguage);
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.storageReadFailed,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }

  Future<QuizCatalogDto> _loadCatalogByLanguage(AppLanguage language) async {
    try {
      final request = await rootBundle.loadString(_assetPathFor(language));
      final decoded = json.decode(request);

      if (decoded is! Map) {
        throw const QuiraException(QuiraError.invalidExternalData);
      }

      final payload = Map<String, dynamic>.from(decoded);
      return QuizCatalogDto.fromJson(payload);
    } on QuiraException {
      rethrow;
    } catch (error, stackTrace) {
      throw QuiraException(
        QuiraError.storageReadFailed,
        innerError: error,
        innerStackTrace: stackTrace,
      );
    }
  }

  String _assetPathFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return _Keys.catalogEnAssetPath;
      case AppLanguage.pt:
        return _Keys.catalogPtAssetPath;
    }
  }
}
