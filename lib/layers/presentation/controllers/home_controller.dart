import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:quira/core/errors/quira_error.dart';
import 'package:quira/core/errors/quira_exception.dart';
import 'package:quira/core/language/app_language.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_answer_entity.dart';
import 'package:quira/layers/domain/entities/attempt/quiz_attempt_entity.dart';
import 'package:quira/layers/domain/entities/catalog/quiz_entity.dart';
import 'package:quira/layers/domain/usecases/delete_attempt_by_quiz_id_usecase.dart';
import 'package:quira/layers/domain/usecases/get_all_attempts_usecase.dart';
import 'package:quira/layers/domain/usecases/get_all_quizzes_usecase.dart';

enum HomeLoadStatus { initial, loading, loaded, error }

class HomeController extends ChangeNotifier {
  final GetAllQuizzesUseCase _getAllQuizzesUseCase;
  final GetAllAttemptsUseCase _getAllAttemptsUseCase;
  final DeleteAttemptByQuizIdUseCase _deleteAttemptByQuizIdUseCase;

  HomeController(
    this._getAllQuizzesUseCase,
    this._getAllAttemptsUseCase,
    this._deleteAttemptByQuizIdUseCase,
  );

  HomeLoadStatus _status = HomeLoadStatus.initial;
  QuiraError? _error;
  List<QuizEntity> _quizzes = const [];
  Map<int, List<QuizAnswerEntity>> _answersByQuizId = const {};

  HomeLoadStatus get status => _status;

  QuiraError? get error => _error;

  UnmodifiableListView<QuizEntity> get quizzes =>
      UnmodifiableListView(_quizzes);

  Future<void> load(AppLanguage language) async {
    _status = HomeLoadStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _quizzes = await _getAllQuizzesUseCase(language);
      final attempts = await _getAllAttemptsUseCase();
      _answersByQuizId = _mapAnswersByQuizId(attempts);
      _status = HomeLoadStatus.loaded;
      notifyListeners();
    } on QuiraException catch (error) {
      _status = HomeLoadStatus.error;
      _error = error.cause;
      notifyListeners();
    } catch (_) {
      _status = HomeLoadStatus.error;
      _error = QuiraError.unknown;
      notifyListeners();
    }
  }

  Future<void> refreshAttempts() async {
    final attempts = await _getAllAttemptsUseCase();
    _answersByQuizId = _mapAnswersByQuizId(attempts);
    notifyListeners();
  }

  Future<void> restartQuiz(int quizId) async {
    await _deleteAttemptByQuizIdUseCase(quizId);
    final updatedAnswers = Map<int, List<QuizAnswerEntity>>.from(
      _answersByQuizId,
    );
    updatedAnswers.remove(quizId);
    _answersByQuizId = updatedAnswers;
    notifyListeners();
  }

  bool isQuizAnswered(int quizId) {
    return _answersByQuizId.containsKey(quizId);
  }

  List<QuizAnswerEntity> answersForQuiz(int quizId) {
    return List<QuizAnswerEntity>.from(_answersByQuizId[quizId] ?? const []);
  }

  int countCorrectAnswers({
    required QuizEntity quiz,
    required List<QuizAnswerEntity> answers,
  }) {
    var totalCorrectAnswers = 0;

    for (final answer in answers) {
      final question = quiz.questions.where((item) {
        return item.id == answer.questionId;
      }).firstOrNull;

      if (question == null) {
        continue;
      }

      if (question.correctAlternativeId == answer.selectedAlternativeId) {
        totalCorrectAnswers++;
      }
    }

    return totalCorrectAnswers;
  }

  Map<int, List<QuizAnswerEntity>> _mapAnswersByQuizId(
    List<QuizAttemptEntity> attempts,
  ) {
    final answersByQuizId = <int, List<QuizAnswerEntity>>{};
    for (final attempt in attempts) {
      answersByQuizId[attempt.quizId] = List<QuizAnswerEntity>.from(
        attempt.answers,
      );
    }
    return answersByQuizId;
  }
}
