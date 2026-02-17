// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Quira';

  @override
  String get homeTagline => 'Fast quizzes with instant feedback';

  @override
  String homeCompletedMetric(int completed, int total) {
    return '$completed / $total completed';
  }

  @override
  String get homeLoadErrorTitle => 'Could not load quizzes';

  @override
  String get homeTryAgain => 'Try again';

  @override
  String get homeNoQuizzesTitle => 'No quizzes available';

  @override
  String get homeNoQuizzesMessage => 'Your quiz catalog is empty right now.';

  @override
  String get homeRefresh => 'Refresh';

  @override
  String get homeTapToReviewAnswers => 'Tap to review your answers';

  @override
  String get homeTapToStartQuiz => 'Tap to start this quiz';

  @override
  String get quizNoQuestions => 'This quiz has no questions.';

  @override
  String get quizSaving => 'Saving...';

  @override
  String get quizFinish => 'Finish quiz';

  @override
  String get quizNextQuestion => 'Next question';

  @override
  String get quizIncompleteTitle => 'Incomplete quiz';

  @override
  String get quizIncompleteMessage => 'Answer all questions before finishing.';

  @override
  String get resultNoQuestions =>
      'This quiz has no questions to show in the result view.';

  @override
  String get resultCompletedTitle => 'Quiz completed';

  @override
  String resultCorrectCount(int correct, int total) {
    return '$correct out of $total correct answers';
  }

  @override
  String get resultStatusUnanswered => 'Unanswered';

  @override
  String get resultStatusCorrect => 'Correct';

  @override
  String get resultStatusIncorrect => 'Incorrect';

  @override
  String get resultYourAnswerLabel => 'Your answer';

  @override
  String get resultNotAnswered => 'Not answered';

  @override
  String get resultCorrectAnswerLabel => 'Correct answer';

  @override
  String get resultUnavailable => 'Unavailable';

  @override
  String get resultRestarting => 'Restarting...';

  @override
  String get resultRedoQuiz => 'Redo quiz';

  @override
  String resultQuestionTitle(int number, Object prompt) {
    return '$number - $prompt';
  }

  @override
  String get errorInvalidExternalData => 'Some external data is invalid.';

  @override
  String get errorStorageReadFailed => 'Unable to read local data.';

  @override
  String get errorStorageWriteFailed => 'Unable to save local data.';

  @override
  String get errorInvalidParams => 'Invalid parameters.';

  @override
  String get errorUnknown => 'Unexpected error.';
}
