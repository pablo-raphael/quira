import 'package:flutter/widgets.dart';
import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/l10n/app_localizations.dart';

extension QuiraErrorLocalizationExtension on QuiraError {
  String localizedText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case QuiraError.invalidExternalData:
        return l10n.errorInvalidExternalData;
      case QuiraError.storageReadFailed:
        return l10n.errorStorageReadFailed;
      case QuiraError.storageWriteFailed:
        return l10n.errorStorageWriteFailed;
      case QuiraError.invalidParams:
        return l10n.errorInvalidParams;
      case QuiraError.unknown:
        return l10n.errorUnknown;
    }
  }
}
