import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Quira'**
  String get appTitle;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Fast quizzes with instant feedback'**
  String get homeTagline;

  /// No description provided for @homeCompletedMetric.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total} completed'**
  String homeCompletedMetric(int completed, int total);

  /// No description provided for @homeLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load quizzes'**
  String get homeLoadErrorTitle;

  /// No description provided for @homeTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeTryAgain;

  /// No description provided for @homeNoQuizzesTitle.
  ///
  /// In en, this message translates to:
  /// **'No quizzes available'**
  String get homeNoQuizzesTitle;

  /// No description provided for @homeNoQuizzesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your quiz catalog is empty right now.'**
  String get homeNoQuizzesMessage;

  /// No description provided for @homeRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get homeRefresh;

  /// No description provided for @homeTapToReviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Tap to review your answers'**
  String get homeTapToReviewAnswers;

  /// No description provided for @homeTapToStartQuiz.
  ///
  /// In en, this message translates to:
  /// **'Tap to start this quiz'**
  String get homeTapToStartQuiz;

  /// No description provided for @quizNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'This quiz has no questions.'**
  String get quizNoQuestions;

  /// No description provided for @quizSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get quizSaving;

  /// No description provided for @quizFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish quiz'**
  String get quizFinish;

  /// No description provided for @quizNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get quizNextQuestion;

  /// No description provided for @quizIncompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Incomplete quiz'**
  String get quizIncompleteTitle;

  /// No description provided for @quizIncompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Answer all questions before finishing.'**
  String get quizIncompleteMessage;

  /// No description provided for @resultNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'This quiz has no questions to show in the result view.'**
  String get resultNoQuestions;

  /// No description provided for @resultCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz completed'**
  String get resultCompletedTitle;

  /// No description provided for @resultCorrectCount.
  ///
  /// In en, this message translates to:
  /// **'{correct} out of {total} correct answers'**
  String resultCorrectCount(int correct, int total);

  /// No description provided for @resultStatusUnanswered.
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get resultStatusUnanswered;

  /// No description provided for @resultStatusCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get resultStatusCorrect;

  /// No description provided for @resultStatusIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get resultStatusIncorrect;

  /// No description provided for @resultYourAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get resultYourAnswerLabel;

  /// No description provided for @resultNotAnswered.
  ///
  /// In en, this message translates to:
  /// **'Not answered'**
  String get resultNotAnswered;

  /// No description provided for @resultCorrectAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get resultCorrectAnswerLabel;

  /// No description provided for @resultUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get resultUnavailable;

  /// No description provided for @resultRestarting.
  ///
  /// In en, this message translates to:
  /// **'Restarting...'**
  String get resultRestarting;

  /// No description provided for @resultRedoQuiz.
  ///
  /// In en, this message translates to:
  /// **'Redo quiz'**
  String get resultRedoQuiz;

  /// No description provided for @resultQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'{number} - {prompt}'**
  String resultQuestionTitle(int number, Object prompt);

  /// No description provided for @errorInvalidExternalData.
  ///
  /// In en, this message translates to:
  /// **'Some external data is invalid.'**
  String get errorInvalidExternalData;

  /// No description provided for @errorStorageReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to read local data.'**
  String get errorStorageReadFailed;

  /// No description provided for @errorStorageWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to save local data.'**
  String get errorStorageWriteFailed;

  /// No description provided for @errorInvalidParams.
  ///
  /// In en, this message translates to:
  /// **'Invalid parameters.'**
  String get errorInvalidParams;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error.'**
  String get errorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
