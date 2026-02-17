// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Quira';

  @override
  String get homeTagline => 'Quizzes rápidos com feedback imediato';

  @override
  String homeCompletedMetric(int completed, int total) {
    return '$completed / $total concluídos';
  }

  @override
  String get homeLoadErrorTitle => 'Não foi possível carregar os quizzes';

  @override
  String get homeTryAgain => 'Tentar novamente';

  @override
  String get homeNoQuizzesTitle => 'Nenhum quiz disponível';

  @override
  String get homeNoQuizzesMessage =>
      'Seu catálogo de quizzes está vazio no momento.';

  @override
  String get homeRefresh => 'Atualizar';

  @override
  String get homeTapToReviewAnswers => 'Toque para revisar suas respostas';

  @override
  String get homeTapToStartQuiz => 'Toque para iniciar este quiz';

  @override
  String get quizNoQuestions => 'Este quiz não possui perguntas.';

  @override
  String get quizSaving => 'Salvando...';

  @override
  String get quizFinish => 'Finalizar quiz';

  @override
  String get quizNextQuestion => 'Próxima pergunta';

  @override
  String get quizIncompleteTitle => 'Quiz incompleto';

  @override
  String get quizIncompleteMessage =>
      'Responda todas as perguntas antes de finalizar.';

  @override
  String get resultNoQuestions =>
      'Este quiz não possui perguntas para exibir no resultado.';

  @override
  String get resultCompletedTitle => 'Quiz concluído';

  @override
  String resultCorrectCount(int correct, int total) {
    return '$correct de $total respostas corretas';
  }

  @override
  String get resultStatusUnanswered => 'Não respondida';

  @override
  String get resultStatusCorrect => 'Correta';

  @override
  String get resultStatusIncorrect => 'Incorreta';

  @override
  String get resultYourAnswerLabel => 'Sua resposta';

  @override
  String get resultNotAnswered => 'Não respondida';

  @override
  String get resultCorrectAnswerLabel => 'Resposta correta';

  @override
  String get resultUnavailable => 'Indisponível';

  @override
  String get resultRestarting => 'Reiniciando...';

  @override
  String get resultRedoQuiz => 'Refazer quiz';

  @override
  String resultQuestionTitle(int number, Object prompt) {
    return '$number - $prompt';
  }

  @override
  String get errorInvalidExternalData =>
      'Alguns dados externos estão inválidos.';

  @override
  String get errorStorageReadFailed => 'Não foi possível ler os dados locais.';

  @override
  String get errorStorageWriteFailed =>
      'Não foi possível salvar os dados locais.';

  @override
  String get errorInvalidParams => 'Parâmetros inválidos.';

  @override
  String get errorUnknown => 'Erro inesperado.';
}
