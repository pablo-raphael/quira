import 'package:flutter/widgets.dart';

enum AppLanguage {
  en,
  pt;

  static AppLanguage fromLocale(Locale locale) {
    switch (locale.languageCode.toLowerCase()) {
      case 'pt':
        return AppLanguage.pt;
      case 'en':
      default:
        return AppLanguage.en;
    }
  }
}
